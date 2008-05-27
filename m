Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbYE0Aem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbYE0Aem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 20:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbYE0Aeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 20:34:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:30995 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbYE0Aea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 20:34:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=RtD2nVPrqWqZhBFLQOrD3NbiH9JhnOaQmBPyHfbuokWZF3HFW8rD+2AcSmoT/y9It
	wCG05HSo77O+XibedUVwg==
Message-ID: <da824cf30805261734g6dbd43yfda62124973b98cf@mail.gmail.com>
Date: Mon, 26 May 2008 17:34:25 -0700
From: "Grant Grundler" <grundler@google.com>
To: "Mark Lord" <liml@rtr.ca>
Subject: Re: Marvell 88SX7042 [4 Port SATA PCI-Express x4] Support/Questions
Cc: "Justin Piszcz" <jpiszcz@lucidpixels.com>, "Jeff Garzik" <jeff@garzik.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
In-Reply-To: <4839A63E.4050409@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.10.0805250757550.18572@p34.internal.lan>
	 <4839A63E.4050409@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 10:47 AM, Mark Lord <liml@rtr.ca> wrote:
...
> Sure, if the bus and memory are fast enough.  You'll hit the Linux/libata
> transactions/sec limit at some point, but I don't know what that is.
>
> Eg. Here's a 4X (I think) card in my PCIe video slot:
>
> beefy:~# mdadm --create /dev/md0 --chunk=256 -l 0 --raid-devices=4
> /dev/sd[bcde]
> mdadm: array /dev/md0 started.
>
> beefy:~# hdparm -t --direct /dev/sd[bcde] /dev/md0
>
> /dev/sdb:
> Timing O_DIRECT disk reads:  218 MB in  3.01 seconds =  72.46 MB/sec
>
> /dev/sdc:
> Timing O_DIRECT disk reads:  256 MB in  3.01 seconds =  85.00 MB/sec
>
> /dev/sdd:
> Timing O_DIRECT disk reads:  192 MB in  3.01 seconds =  63.79 MB/sec
>
> /dev/sde:
> Timing O_DIRECT disk reads:  256 MB in  3.01 seconds =  85.07 MB/sec
>
> /dev/md0:
> Timing O_DIRECT disk reads:  768 MB in  3.00 seconds = 255.69 MB/sec

The bottle neck here is with the four disks.
Modern 1TB 7200 rpm disks have raw throughput rates up to around
100MB/s. Anything in the last 4-5 years should do better than 60MB/s.

In theory, ~16 disks (4 disks per 7042 port using Port Mulitpliers),
one should be able to hit 200+ MB/s per 7042 port and approach 900MB/s
total. Getting more than 900Mb/s will depend on the chipset. IIRC, the
MMRBC of 128 bytes will result in about 15% protocol overhead in the
PCI-e link.
Bigger PCI-e "burst" will result in dramatically less overhead (IIRC,
256Byte == 9% overhead.)

hth,
grant
