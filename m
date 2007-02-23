Return-Path: <linux-kernel-owner+w=401wt.eu-S932324AbXBWMv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbXBWMv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 07:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932318AbXBWMv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 07:51:28 -0500
Received: from customer-domains.icp-qv1-irony7.iinet.net.au ([203.59.1.128]:47978
	"EHLO customer-domains.icp-qv1-irony7.iinet.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932324AbXBWMv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 07:51:27 -0500
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Feb 2007 07:51:26 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAPdu3kXLzhXtUGdsb2JhbAANjxQBASqTFwEBAQ
X-IronPort-AV: i="4.14,211,1170604800"; 
   d="scan'208"; a="505869037:sNHT15282632"
Subject: Re: 2.6.20: stripe_cache_size goes boom with 32mb
From: Jason Rainforest <l3mming@iinet.net.au>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0702230640430.3781@p34.internal.lan>
References: <Pine.LNX.4.64.0702230640430.3781@p34.internal.lan>
Content-Type: text/plain
Date: Fri, 23 Feb 2007 22:41:00 +1000
Message-Id: <1172234460.4419.7.camel@merlin>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin,

I'm not a RAID or kernel developer, but .. do you have enough RAM to
support a 32mb stripe_cache_size?! Here on my 7*250Gb SW RAID5 array,
decreasing a stripe_cache_size of 8192 to 4096 frees up no less than
120mb of RAM. Using that as a calculation tool, a 32mb stripe_cache_size
would require approximately 960mb of RAM! My RAID box only has 1Gb of
RAM, so I'm not game to test such a thing. Others on these lists would
definitely have a good idea on what's happening :-)

Cheers,
Jason


On Fri, 2007-02-23 at 06:41 -0500, Justin Piszcz wrote:
> Each of these are averaged over three runs with 6 SATA disks in a SW RAID 
> 5 configuration:
> 
> (dd if=/dev/zero of=file_1 bs=1M count=2000)
> 
> 128k_stripe: 69.2MB/s
> 256k_stripe: 105.3MB/s
> 512k_stripe: 142.0MB/s
> 1024k_stripe: 144.6MB/s
> 2048k_stripe: 208.3MB/s
> 4096k_stripe: 223.6MB/s
> 8192k_stripe: 226.0MB/s
> 16384k_stripe: 215.0MB/s
> 
> When I tried a 32768k stripe, this happened:
> p34:~# echo 32768 > /sys/block/md4/md/stripe_cache_size
> Connection to p34 closed
> 
> I was able to Alt-SysRQ+b but I could not access the console/X/etc, it 
> appeared to be frozen.
> 
> FYI.
> 
> Justin.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
