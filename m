Return-Path: <linux-kernel-owner+w=401wt.eu-S1762750AbXJYXiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762750AbXJYXiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbXJYXht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:37:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46223 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761297AbXJYXhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:37:48 -0400
Date: Thu, 25 Oct 2007 16:37:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Russ Dill" <russ.dill@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Better document profile=
Message-Id: <20071025163743.7a3d8231.akpm@linux-foundation.org>
In-Reply-To: <f9d2a5e10710162216s149c16a3j9bb63d60fdf1e782@mail.gmail.com>
References: <f9d2a5e10710162216s149c16a3j9bb63d60fdf1e782@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 22:16:47 -0700
"Russ Dill" <russ.dill@gmail.com> wrote:

> Be more explicit on what the step/bucket size accomplishes.
> 
> Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
> ---
>  Documentation/kernel-parameters.txt |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt
> b/Documentation/kernel-parameters.txt
> index eb24799..3c6fd27 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1427,7 +1427,10 @@ and is between 256 and 4096 characters. It is
> defined in the file

Your email client is wordwrapping the patches.

>  			Format: [schedule,]<number>
>  			Param: "schedule" - profile schedule points.
>  			Param: <number> - step/bucket size as a power of 2 for
> -				statistical time based profiling.
> +				statistical time based profiling. A value of
> +				2 will provide a granularity of 4 bytes, a
> +				value of 3 will provide a granularity of 8
> +				bytes and so on.
>  			Param: "sleep" - profile D-state sleeping (millisecs)

Actually the prof_shift isn't in units of bytes: it is in units of
sizeof(unsigned long).

So on a 64-bit kernel, prof_shift=2 will give a granularity of 8<<2 bytes
and on a 32-bit kernel, prof_shift=3 will give a granularity of 4<<3 bytes.
