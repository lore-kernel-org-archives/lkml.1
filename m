Return-Path: <linux-kernel-owner+w=401wt.eu-S1750935AbXBLAEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935AbXBLAEF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 19:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbXBLAEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 19:04:04 -0500
Received: from customer-domains.icp-qv1-irony15.iinet.net.au ([203.59.1.175]:61186
	"EHLO customer-domains.icp-qv1-irony15.iinet.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbXBLAEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 19:04:01 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CADY+z0V8qGxQdGdsb2JhbACgfwEBAQ
X-IronPort-AV: i="4.13,311,1167580800"; 
   d="scan'208"; a="52499535:sNHT327483420"
From: "Marc Marais" <marcm@liquid-nexus.net>
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: md: md6_raid5 crash 2.6.20
Date: Mon, 12 Feb 2007 08:03:57 +0800
Message-Id: <20070212000042.M73586@liquid-nexus.net>
In-Reply-To: <17871.37497.786198.834303@notabene.brown>
References: <20070211071527.M31642@liquid-nexus.net> <17871.37497.786198.834303@notabene.brown>
X-Mailer: Open WebMail 2.51 20050627
X-OriginatingIP: 159.99.34.18 (marc)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Feb 2007 09:02:33 +1100, Neil Brown wrote
> On Sunday February 11, marcm@liquid-nexus.net wrote:
> > Greetings,
> > 
> > I've been running md on my server for some time now and a few days ago one of
> > the (3) drives in the raid5 array starting giving read errors. The result was
> > usually system hangs and this was with kernel 2.6.17.13. I upgraded to the
> > latest production 2.6.20 kernel and experienced the same behaviour.
> 
> System hangs suggest a problem with the drive controller.  However
> this "kernel BUG" is something newly introduced in 2.6.20 which 
> should be fixed in 2.6.20.1.  Patch is below.
> 
> If you still get hangs with this patch installed, then please report
> detail, and probably copy to linux-ide@vger.kernel.org.
> 
> NeilBrown
> 
> Fix various bugs with aligned reads in RAID5.
> 
> It is possible for raid5 to be sent a bio that is too big
> for an underlying device.  So if it is a READ that we
> pass stright down to a device, it will fail and confuse
> RAID5.
> 
> So in 'chunk_aligned_read' we check that the bio fits within the
> parameters for the target device and if it doesn't fit, fall back
> on reading through the stripe cache and making lots of one-page
> requests.
> 
> Note that this is the earliest time we can check against the device
> because earlier we don't have a lock on the device, so it could 
> change underneath us.
> 
> Also, the code for handling a retry through the cache when a read
> fails has not been tested and was badly broken.  This patch fixes 
> that code.
> 
> Signed-off-by: Neil Brown <neilb@suse.de>
> 

Thanks for the quick response Neil unfortunately the kernel doesn't build with
this patch due to a missing symbol:

WARNING: "blk_recount_segments" [drivers/md/raid456.ko] undefined!

Is that in another file that needs patching or within raid5.c?

Marc

--
