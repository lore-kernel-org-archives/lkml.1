Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbXLLCut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbXLLCut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 21:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbXLLCul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 21:50:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbXLLCuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 21:50:40 -0500
Date: Tue, 11 Dec 2007 21:50:32 -0500
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marcin __lusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [PATCH] fbcon: fix sparse warning about shadowing 'p' symbol
Message-ID: <20071212025032.GA21298@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marcin __lusarz <marcin.slusarz@gmail.com>,
	linux-kernel@vger.kernel.org, adaplas@gmail.com
References: <20071209213429.GE9440@joi> <20071211165700.fb20c939.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211165700.fb20c939.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 04:57:00PM -0800, Andrew Morton wrote:

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

in the same function.
We have quite a few shadow warnings in that file.

drivers/video/console/fbcon.c:337:25: warning: symbol '_x' shadows an earlier one
drivers/video/console/fbcon.c:337:25: originally declared here
drivers/video/console/fbcon.c:337:25: warning: symbol '_x' shadows an earlier one
drivers/video/console/fbcon.c:337:25: originally declared here
drivers/video/console/fbcon.c:337:25: warning: symbol '_y' shadows an earlier one
drivers/video/console/fbcon.c:337:25: originally declared here
drivers/video/console/fbcon.c:2813:19: warning: symbol 'p' shadows an earlier one
drivers/video/console/fbcon.c:2798:17: originally declared here
drivers/video/console/fbcon.c:3336:6: warning: symbol 'rotate' shadows an earlier one
drivers/video/console/fbcon.c:150:12: originally declared here
drivers/video/console/fbcon.c:3361:6: warning: symbol 'rotate' shadows an earlier one
drivers/video/console/fbcon.c:150:12: originally declared here
drivers/video/console/fbcon.c:3385:6: warning: symbol 'rotate' shadows an earlier one
drivers/video/console/fbcon.c:150:12: originally declared here

	Dave 


-- 
http://www.codemonkey.org.uk
