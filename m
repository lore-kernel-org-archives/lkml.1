Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbZKCMR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbZKCMR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 07:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZKCMRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 07:17:55 -0500
Received: from smtprelay03.ispgateway.de ([80.67.18.15]:47399 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbZKCMRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 07:17:55 -0500
X-Greylist: delayed 102951 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Nov 2009 07:17:54 EST
Message-ID: <4AF01F72.2030605@ladisch.de>
Date: Tue, 03 Nov 2009 13:17:54 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: James Simmons <jsimmons@infradead.org>
CC: Dave Airlie <airlied@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>, dri-devel@lists.sourceforge.net,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] DRM/KMS framebuffer fixes
References: <4AEE8CDD.10600@ladisch.de> <4AEE8D6F.60209@ladisch.de> <alpine.LFD.2.00.0911021431360.30135@casper.infradead.org>
In-Reply-To: <alpine.LFD.2.00.0911021431360.30135@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Simmons wrote:
>> Without an allocated colormap, FBIOGETCMAP fails.  This would make
>> programs restore an all-black colormap ("links -g") or fail to work
>> altogether ("mplayer -vo fbdev2").
>> 
>> --- linux-2.6/drivers/gpu/drm/i915/intel_fb.c
>> +++ linux-2.6/drivers/gpu/drm/i915/intel_fb.c
>> @@ -227,6 +227,10 @@ static int intelfb_create(struct drm_dev
>>  
>>  	fb->fbdev = info;
>>  
>> +	ret = fb_alloc_cmap(&info->cmap, 256, 0);
>> +	if (ret)
>> +		goto out_unpin;
>> +
>>  	par->intel_fb = intel_fb;
> 
> It would be better to place that code in drm_fb_helper_single_fb_probe.

Thanks, I wasn't quite able to untangle the indirections between the
four framebuffer structures.

New patch set follows.
