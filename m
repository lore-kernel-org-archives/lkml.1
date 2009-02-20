Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbZBTO1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbZBTO1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 09:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbZBTO1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 09:27:09 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:38598 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbZBTO1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 09:27:08 -0500
Date: Fri, 20 Feb 2009 14:27:05 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: General question (scheduler) with SSDs?
Message-ID: <20090220142705.GA429@silver.sucs.org>
References: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan> <20090220094356.GB26124@silver.sucs.org> <ac3eb2510902200316m387ecb45n86a2ea7c6196b01@mail.gmail.com> <20090220131209.GA21446@silver.sucs.org> <ac3eb2510902200523o619e64aas7bffac9aeca86814@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510902200523o619e64aas7bffac9aeca86814@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 02:23:38PM +0100, Kay Sievers wrote:
> On Fri, Feb 20, 2009 at 14:12, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> >
> > I tried
> > SUBSYSTEM=="block", ATTRS{model}=="ASUS-PHISON *", ATTR{queue/rotational}="0"
> > but udevtest /sys/block/sda/ doesn't list it as firing (udev 117-8)...
> 
> I does here:
>   udev_rules_apply_to_event: ATTR '/sys/devices/ ...
> /sdb/queue/rotational' writing '0'
> 
>   $grep . /sys/class/block/*/queue/rotational
>   /sys/class/block/sda/queue/rotational:1
>   /sys/class/block/sdb/queue/rotational:0
> 
> Maybe "udevtest" is not showing it for you, or udev 117 is too old and
> does not work that way.

After you mentioned this I tried again and seemingly I was mistaken - it
does work as you described. I had to make a slight rule tweak to stop
it matching on partitions though:

SUBSYSTEM=="block", KERNEL=="[sh]d[a-z]", ATTRS{model}=="ASUS-PHISON *", ATTR{queue/rotational}="0"
SUBSYSTEM=="block", KERNEL=="[sh]d[a-z]", ATTRS{idVendor}=="0951", ATTRS{idProduct}=="1606", ATTR{queue/rotational}="0"
SUBSYSTEM=="block", KERNEL=="[sh]d[a-z]", ATTRS{manufacturer}=="SanDisk", ATTRS{product}=="Cruzer Micro", ATTR{queue/rotational}="0"

Thanks!

-- 
Sitsofe | http://sucs.org/~sits/
