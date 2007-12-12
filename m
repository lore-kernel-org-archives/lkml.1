Return-Path: <linux-kernel-owner+w=401wt.eu-S1760144AbXLLTX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144AbXLLTX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbXLLTXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:23:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52381
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751714AbXLLTXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:23:22 -0500
Date: Wed, 12 Dec 2007 11:23:21 -0800 (PST)
Message-Id: <20071212.112321.250771549.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org, adaplas@gmail.com
Subject: Re: [PATCH] fbcon: fix sparse warning about shadowing 'p' symbol
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071211165700.fb20c939.akpm@linux-foundation.org>
References: <20071209213429.GE9440@joi>
	<20071211165700.fb20c939.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 11 Dec 2007 16:57:00 -0800

> On Sun, 9 Dec 2007 22:34:33 +0100
> Marcin __lusarz <marcin.slusarz@gmail.com> wrote:
> 
> > fbcon: fix sparse warning about shadowing 'p' symbol
> > 
> 
> Please always quote error messages and warnings in the changelog when
> fixing them, thanks.
> 
> > ---
> >  drivers/video/console/fbcon.c |   10 +++++-----
> >  1 files changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
> > index 0f32f4a..849e114 100644
> > --- a/drivers/video/console/fbcon.c
> > +++ b/drivers/video/console/fbcon.c
> > @@ -2795,7 +2795,7 @@ static int fbcon_scrolldelta(struct vc_data *vc, int lines)
> >  {
> >  	struct fb_info *info = registered_fb[con2fb_map[fg_console]];
> >  	struct fbcon_ops *ops = info->fbcon_par;
> > -	struct display *p = &fb_display[fg_console];
> > +	struct display *disp = &fb_display[fg_console];
> 
> We have a global symbol called "p"?  That would be bad.  Where is it?

I'm curious about this too.

Ahh, I see, look down a few lines in fbcon_scrolldelta(), we have:

			if (logo_shown == vc->vc_num) {
				unsigned long p, q;
				int i;

and that's where the warning is coming from.
