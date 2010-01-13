Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806Ab0AMPJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab0AMPJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728Ab0AMPJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:09:18 -0500
Received: from khc.piap.pl ([195.187.100.11]:53605 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714Ab0AMPJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:09:17 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Greg KH <gregkh@suse.de>
Cc: Ben Hutchings <bhutchings@solarflare.com>, Tilman Schmidt <tilman@imap.cc>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Karsten Keil <isdn@linux-pingi.de>, isdn4linux@listserv.isdn4linux.de
Subject: Re: Can we remove pci_find_device() yet?
References: <20100108112236.462a3da2.sfr@canb.auug.org.au>
	<20100108044646.GC6611@suse.de> <4B4B802A.2010709@imap.cc>
	<20100111200136.GA29955@suse.de> <m3fx6bxdt7.fsf@intrepid.localdomain>
	<1263329605.3011.8.camel@achroite.uk.solarflarecom.com>
	<20100112211801.GA27999@suse.de>
Date: Wed, 13 Jan 2010 16:09:11 +0100
In-Reply-To: <20100112211801.GA27999@suse.de> (Greg KH's message of "Tue, 12
	Jan 2010 13:18:01 -0800")
Message-ID: <m3r5pu6nzc.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

>> One of our older controllers had a similar design error in that the two
>> functions would sometimes have to be reset together.  The way we look
>> for the second function is:
>> 
>> 	dev = pci_dev_get(dev1);
>> 	while ((dev = pci_get_device(vendor_id, device_id, dev))) {
>> 		if (dev->bus == dev1->bus &&
>> 		    dev->devfn == dev1->devfn + 1) {
>> 			dev2 = dev;
>> 			break;
>> 		}
>> 	}
>> 
>> I assume this is 'properly' since no-one has told me otherwise.
>
> As of right now, yes, this is the "correct" way to do this.
>
> I need to dig up the "let multiple drivers bind to a single device"
> patch set to make this not necessary in the future.

Ben and Greg, thanks.
-- 
Krzysztof Halasa
