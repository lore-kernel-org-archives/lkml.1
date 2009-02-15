Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbZBOJ1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbZBOJ1c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 04:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZBOJ1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 04:27:20 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:49077 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbZBOJ1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 04:27:19 -0500
Date: Sun, 15 Feb 2009 10:27:07 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Shem Multinymous <multinymous@gmail.com>
Cc: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rlove@rlove.org, protasnb@gmail.com,
       Michael Ruoss <miruoss@student.ethz.ch>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Frank Seidel <frank@f-seidel.de>
Subject: Re: [PATCH] hwmon/hdaps: Fix bug 7154 inversion of separate axis
Message-ID: <20090215102707.174e770f@hyperion.delvare>
In-Reply-To: <41840b750902141632l5c4bd705m1b528900466a25fd@mail.gmail.com>
References: <499569A9.5030202@suse.de>
	<41840b750902141632l5c4bd705m1b528900466a25fd@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Feb 2009 19:32:02 -0500, Shem Multinymous wrote:
> Hi Frank,
> 
> On Fri, Feb 13, 2009 at 7:38 AM, Frank Seidel <fseidel@suse.de> wrote:
> > From: Frank Seidel <frank@f-seidel.de>
> >
> > Fix for kernel.org bug #7154:hdaps inversion of
> > each axis. This version is based on the work
> > from Michael Ruoss <miruoss@student.ethz.ch>.
> >
> > Signed-off-by: Frank Seidel <frank@f-seidel.de>
> > ---
> >  drivers/hwmon/hdaps.c |   49 ++++++++++++++++++++++++++++---------------------
> >  1 file changed, 28 insertions(+), 21 deletions(-)
> >
> > --- a/drivers/hwmon/hdaps.c
> > +++ b/drivers/hwmon/hdaps.c
> > @@ -65,6 +65,10 @@
> >  #define HDAPS_INPUT_FUZZ       4       /* input event threshold */
> >  #define HDAPS_INPUT_FLAT       4
> >
> > +#define HDAPS_X_AXIS           1UL
> > +#define HDAPS_Y_AXIS           2UL
> > +#define HDAPS_BOTH_AXES                3UL
> 
> There are more possibilities than these: axes could also switched, for
> a total of 8 possibilities.

Which leads to the simple conclusion that this chip was never meant to
be used as an input device. Think about it: this chip is there to
protect the hard disk drive from shocks. Instead of this we are
proposing to the user to abuse the chip as an input device, that is:
voluntarily shock the laptop. Of course these are small movements,
nothing like a free fall, but I still believe this is conceptually
wrong.

Honestly, who uses this feature in practice? I bet this makes users
laugh for a minute when they discover the feature, and then they forget
about it. I think it would make sense to plain get rid of the input
feature of hdaps.

> See the table at the bottom of the tp_smapi page
> (http://www.thinkwiki.org/wiki/Tp_smapi), or hdaps.c inside the
> tp_smapi package, for more model-specific information.
> It would be nice if you made the interface (constants and their
> meaning) the same as in the tp_smapi version of hdaps, which is
> already widely deployed and packaged by several distros.

Why is this code not upstream? Ah yeah, I remember now: because it was
written by an anonymous developer, which makes the contribution legally
dubious. Copying such code into the upstream version of hdaps would be
no different, so we cannot do that, sorry.

-- 
Jean Delvare
