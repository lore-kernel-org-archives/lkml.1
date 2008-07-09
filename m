Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbYGIEKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbYGIEKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 00:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYGIEKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 00:10:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:10554 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYGIEKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 00:10:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=S0t6WcSDmWO1Y9ghfN+wp3rJBsQaUMmlMsp/lBzWwhDLQBP737Z+3fj9ZXYK/r1qXC
         4tRzKMAK8vlYghpM08FGzCpE0fHT1TvAhoWRd9/RuOp2GR33V3Eiad6J+Wx3AFPBQZpD
         pb1FfuptJ0toslXDJi+OJz1c2PE3Yy+i8qsIg=
Message-ID: <48743A1A.2010304@gmail.com>
Date: Wed, 09 Jul 2008 13:10:02 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Komuro <komurojun-mbn@nifty.com>
CC: Jeff Garzik <jeff@garzik.org>,
       linux-pcmcia <linux-pcmcia@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-ide@vger.kernel.org,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>, jgarzik@redhat.com,
       rjw@sisk.pl
Subject: Re: [KERNEL 2.6.26-rc4]  bugreport : pata_pcmcia with Sandisk Extreme
 III 8GB
References: <20080528225049.9a134e0d.Kristoffer.Ericson@Gmail.com>	<20080528222740.GB20893@isilmar.linta.de>	<20080530135728.be02d3dc.Kristoffer.Ericson@Gmail.com>	<20080607223716.7d142072.komurojun-mbn@nifty.com>	<20080611072029.GB28692@comet.dominikbrodowski.net>	<20080614120055.ad8fbee0.komurojun-mbn@nifty.com>	<48537149.4040102@garzik.org>	<20080614213612.96873c25.komurojun-mbn@nifty.com>	<4855D8E2.10409@gmail.com>	<20080616221145.e3b069b9.komurojun-mbn@nifty.com>	<485669A0.6000404@gmail.com>	<20080617212345.c452d8c5.komurojun-mbn@nifty.com>	<20080706103752.13935ffd.komurojun-mbn@nifty.com>	<4870D46C.7000604@gmail.com> <20080707214253.2406f81a.komurojun-mbn@nifty.com>
In-Reply-To: <20080707214253.2406f81a.komurojun-mbn@nifty.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Komuro wrote:
>> How come ap->lock can get set to bogus address?  Can you please printk
>> &host->lock and ap->lock after ata_host_alloc() without the patch?
> 
> Here is the output of printk.
> Strangely, without the patch, the pata_pcmcia problem happens again.

Ah... super strange.  Can you please try to swap memory sticks around
and see whether anything changes to rule out bad memory?  Another
possibility is DMA corrupting the memory and printk makes the timing
different and dodges the bullet.  Does putting msleep(100) in the
pata_pcmcia init_one make any difference?

Thanks.

-- 
tejun
