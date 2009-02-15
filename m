Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbZBOAcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbZBOAcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 19:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZBOAcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 19:32:06 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:61146 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbZBOAcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 19:32:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Phzf6ydQ0Pogt4e7oJEkeBsZCiFwjg7qS/bB5ERQNkWcMrSLjync9RTrX0FRRLpIk3
         uAhy8XAnuzS2xhXCDS/4MEW20uPtwDJCbu7/eWsj7fUEqM9srOtF0lLv0YNU6dKnHB06
         WyG0i9HnB4H0ilKFq3vsfIZdMkiGNCOmXgO2o=
MIME-Version: 1.0
In-Reply-To: <499569A9.5030202@suse.de>
References: <499569A9.5030202@suse.de>
Date: Sat, 14 Feb 2009 19:32:02 -0500
Message-ID: <41840b750902141632l5c4bd705m1b528900466a25fd@mail.gmail.com>
Subject: Re: [PATCH] hwmon/hdaps: Fix bug 7154 inversion of separate axis
From: Shem Multinymous <multinymous@gmail.com>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rlove@rlove.org, Jean Delvare <khali@linux-fr.org>, protasnb@gmail.com,
       Michael Ruoss <miruoss@student.ethz.ch>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Frank Seidel <frank@f-seidel.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

On Fri, Feb 13, 2009 at 7:38 AM, Frank Seidel <fseidel@suse.de> wrote:
> From: Frank Seidel <frank@f-seidel.de>
>
> Fix for kernel.org bug #7154:hdaps inversion of
> each axis. This version is based on the work
> from Michael Ruoss <miruoss@student.ethz.ch>.
>
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  drivers/hwmon/hdaps.c |   49 ++++++++++++++++++++++++++++---------------------
>  1 file changed, 28 insertions(+), 21 deletions(-)
>
> --- a/drivers/hwmon/hdaps.c
> +++ b/drivers/hwmon/hdaps.c
> @@ -65,6 +65,10 @@
>  #define HDAPS_INPUT_FUZZ       4       /* input event threshold */
>  #define HDAPS_INPUT_FLAT       4
>
> +#define HDAPS_X_AXIS           1UL
> +#define HDAPS_Y_AXIS           2UL
> +#define HDAPS_BOTH_AXES                3UL

There are more possibilities than these: axes could also switched, for
a total of 8 possibilities.
See the table at the bottom of the tp_smapi page
(http://www.thinkwiki.org/wiki/Tp_smapi), or hdaps.c inside the
tp_smapi package, for more model-specific information.
It would be nice if you made the interface (constants and their
meaning) the same as in the tp_smapi version of hdaps, which is
already widely deployed and packaged by several distros.

  Shem
