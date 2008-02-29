Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbYB2LzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbYB2LzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 06:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbYB2Lyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 06:54:51 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44643 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119AbYB2Lyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 06:54:49 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47C7F209.9030907@s5r6.in-berlin.de>
Date: Fri, 29 Feb 2008 12:52:41 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Jarod Wilson <jwilson@redhat.com>, benh@kernel.crashing.org,
       Kristian Hoegsberg <krh@bitplanet.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 1/2] firewire: endianess fix
References: <20080220220326.GA22328@uranus.ravnborg.org>	<200802272221.38985.jwilson@redhat.com>	<1204179959.15052.372.camel@pasglop>	<200802281342.06493.jwilson@redhat.com>	<1204241162.15052.393.camel@pasglop>	<47C79CB1.6050104@redhat.com> <18375.60394.166769.540668@cargo.ozlabs.ibm.com>
In-Reply-To: <18375.60394.166769.540668@cargo.ozlabs.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Jarod Wilson writes:
>> I wonder how many people still actually 1) have a machine 
>> with this controller, 2) are running Linux on it and 3) use firewire 
>> devices with it. Both of you, please speak up, we're trying to help you! 
>> (if only out of morbid curiosity to see this mythical goofy controller).
> 
> I have a first-generation titanium powerbook that has this controller
> (assuming we're talking about vendor/device id = 0x106b / 0x18), and
> yes I run Linux (only) on it and use firewire disks. :)

I actually have a TiBook 400 myself, but so far without Linux, and its 
FireWire PHY is dead.  But I can use CardBus FireWire cards on it to do 
basic testing on a big endian PC, and I can test the selfID 
byte-swapping by the PHY-less onboard controller.

I now started a Fedora 8 live CD (self-test says the medium is 
corrupt... need to burn another one) and dmesg says:
firewire_ohci: Added fw-ohci device 0002:24:0e.0, OHCI version 1.0
firewire_ohci: recursive bus reset detected, discarding self ids
[...]

The second line looks like this is indeed one of those which needs the 
header byte-swap workaround which ohci1394 has but firewire-ohci hasn't yet.

On the weekend I'm going to attempt to put Linux on this PowerBook, at last.
-- 
Stefan Richter
-=====-==--- --=- ===-=
http://arcgraph.de/sr/
