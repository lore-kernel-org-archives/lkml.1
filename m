Return-Path: <linux-kernel-owner+w=401wt.eu-S1760622AbXLLTgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622AbXLLTgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbXLLTgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:36:09 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:51144 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbXLLTgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:36:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=G2AO95J8/6Hb27F7FYq48P7L7KPq6+Hk/B2M4JmliqkW1nw2UbQd8os9Y1xZ/Lxs85uOf8/TaTs0gE5ZNY7mMesGsncPQeaNdaFMOp3Sr00zLbTpYpSXBz103PBx0My0xQc4lE2yDYPfCEkt9KlIKxSEYj1CJifvOhZWdMy/R1U=
Date: Wed, 12 Dec 2007 20:37:28 +0100
From: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [PATCH] fbcon: fix sparse warning about shadowing 'p' symbol
Message-ID: <20071212192446.GA8605@joi>
References: <20071209213429.GE9440@joi> <20071211165700.fb20c939.akpm@linux-foundation.org> <20071212025032.GA21298@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071212025032.GA21298@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 09:50:32PM -0500, Dave Jones wrote:
> On Tue, Dec 11, 2007 at 04:57:00PM -0800, Andrew Morton wrote:
>
>  > > --- a/drivers/video/console/fbcon.c
>  > > +++ b/drivers/video/console/fbcon.c
>  > > @@ -2795,7 +2795,7 @@ static int fbcon_scrolldelta(struct vc_data *vc, int lines)
>  > >  {
>  > >  	struct fb_info *info = registered_fb[con2fb_map[fg_console]];
>  > >  	struct fbcon_ops *ops = info->fbcon_par;
>  > > -	struct display *p = &fb_display[fg_console];
>  > > +	struct display *disp = &fb_display[fg_console];
>  >
>  > We have a global symbol called "p"?  That would be bad.  Where is it?
>
> in the same function.
> We have quite a few shadow warnings in that file.
>
> drivers/video/console/fbcon.c:337:25: warning: symbol '_x' shadows an earlier one
> drivers/video/console/fbcon.c:337:25: originally declared here
> drivers/video/console/fbcon.c:337:25: warning: symbol '_x' shadows an earlier one
> drivers/video/console/fbcon.c:337:25: originally declared here
> drivers/video/console/fbcon.c:337:25: warning: symbol '_y' shadows an earlier one
> drivers/video/console/fbcon.c:337:25: originally declared here
That's from max(A, max(B, C)) and max is defined as:
#define max(x,y) ({ \
        typeof(x) _x = (x);     \
        typeof(y) _y = (y);     \
        (void) (&_x == &_y);            \
        _x > _y ? _x : _y; })

Don't know how to fix it without making the code look uglier...

> drivers/video/console/fbcon.c:3336:6: warning: symbol 'rotate' shadows an earlier one
> drivers/video/console/fbcon.c:150:12: originally declared here
> drivers/video/console/fbcon.c:3361:6: warning: symbol 'rotate' shadows an earlier one
> drivers/video/console/fbcon.c:150:12: originally declared here
> drivers/video/console/fbcon.c:3385:6: warning: symbol 'rotate' shadows an earlier one
> drivers/video/console/fbcon.c:150:12: originally declared here
That's fixed in another patch.

Marcin
