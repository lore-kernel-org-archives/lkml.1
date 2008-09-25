Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbYIYSs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbYIYSs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbYIYSsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:48:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38940 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbYIYSsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:48:13 -0400
Message-ID: <48DBDC92.80605@zytor.com>
Date: Thu, 25 Sep 2008 11:46:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Frans Pop <elendil@planet.nl>, airlied@gmail.com,
       Jeff Garzik <jeff@garzik.org>, davem@davemloft.net,
       Andrew Morton <akpm@linux-foundation.org>, jeffrey.t.kirsher@intel.com,
       david.vrabel@csr.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org,
       jesse.brandeburg@gmail.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
References: <20080923.150722.141587696.davem@davemloft.net> <9929d2390809231512w160d221axa2923a6b293a041@mail.gmail.com> <alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz> <20080923.211215.193696086.davem@davemloft.net> <alpine.LNX.1.10.0809250110070.4671@pegasus.suse.cz> <21d7e9970809241722w7c3bb6a5w1af5801b7380169d@mail.gmail.com> <21d7e9970809241722w7c3bb6a5w1af5801b7380169d@mail.gmail.com> <alpine.LNX.1.10.0809250310190.4671@pegasus.suse.cz> <200809250401.54818.elendil@planet.nl> <Pine.LNX.4.64.0809251921340.18801@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0809251921340.18801@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> 
> Yes, I think that xorg/xorg i915 driver/libdrm/GEM/whatever are the 
> biggest suspect currently, according to the data that has been gathered so 
> far.
> 
> Still, what confuses me a little bit -- the EEPROM of the card is set to 
> all 0xff, once the corruption happens. Isn't that a quite a coincidence, 
> that bytes representing "nothing" in this context are used?
> 

Typical card EEPROMs are serial - either I2C or SPI.  I believe the 
Intel cards use SPI EEPROMs, but I'm not sure.

[Disclaimer: I don't actually know SPI all that well; I know I2C better. 
  However, I'm pretty sure the following argument does apply to both.]

Consider a corruption which turns a read command into a write command -- 
often just a single bit difference.  Now, the EEPROM will expect data in 
to write, but nothing will be driving the data line, so it will 
typically be a 1.  As the host tries to read, it will therefore fill the 
EEPROM with all ones.

	-hpa
