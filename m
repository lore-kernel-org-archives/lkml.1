Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbZKDIkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbZKDIkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 03:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZKDIkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 03:40:35 -0500
Received: from smtprelay10.ispgateway.de ([80.67.31.44]:49526 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZKDIke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 03:40:34 -0500
Message-ID: <4AF13E04.8000005@ladisch.de>
Date: Wed, 04 Nov 2009 09:40:36 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: James Simmons <jsimmons@infradead.org>
CC: Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] DRM/KMS framebuffer fixes
References: <4AEE8CDD.10600@ladisch.de> <4AEE8D6F.60209@ladisch.de> <alpine.LFD.2.00.0911021431360.30135@casper.infradead.org> <4AF01F72.2030605@ladisch.de> <4AF01FFD.50409@ladisch.de> <alpine.LFD.2.00.0911031718160.14442@casper.infradead.org>
In-Reply-To: <alpine.LFD.2.00.0911031718160.14442@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Simmons wrote:
> > @@ -905,6 +905,9 @@ int drm_fb_helper_single_fb_probe(struct
> >  
> >  	if (new_fb) {
> >  		info->var.pixclock = 0;
> > +		ret = fb_alloc_cmap(&info->cmap, crtc->gamma_size, 0);
> > +		if (ret)
> > +			return ret;
> 
> >  		if (register_framebuffer(info) < 0) {
> 			fb_dealloc_cmap(info->cmap);	
> >  			return -EINVAL;
> 		}
> 
> Plug memory leak.

Oops.  Thanks again.
New patch set follows:

 include/drm/drm_crtc.h          |    2 +-
 drivers/gpu/drm/drm_fb_helper.c |   14 ++++++++++----
 2 files changed, 11 insertions(+), 5 deletions(-)

v2: incorporated suggestions by James Simmons
v3: bugfix by James Simmons
