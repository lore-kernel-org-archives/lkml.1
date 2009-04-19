Return-Path: <linux-kernel-owner+w=401wt.eu-S1751460AbZDSXDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbZDSXDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 19:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbZDSXDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 19:03:41 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:52699 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZDSXDl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 19:03:41 -0400
MIME-Version: 1.0
In-Reply-To: <495563870904181941o5a66126dgb59d8cad2b7a66f2@mail.gmail.com>
References: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
	 <74c0088dfda1816c21914c0a8da0c42908526c5e.1239874968.git.monstr@monstr.eu>
	 <20090417170707.B6C95C4004F@mail150-wa4.bigfish.com>
	 <fa686aa40904172249m5e261492w48c8d9d8446600e0@mail.gmail.com>
	 <495563870904181941o5a66126dgb59d8cad2b7a66f2@mail.gmail.com>
Date: Mon, 20 Apr 2009 09:03:40 +1000
Message-ID: <1d3f23370904191603s37a6a34clccc397707394650b@mail.gmail.com>
Subject: Re: [microblaze-uclinux] [PATCH 11/11] microblaze: Kconfig: Enable 
	drivers for Microblaze
From: John Williams <john.williams@petalogix.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>, linux-kernel@vger.kernel.org,
       John Linn <john.linn@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 12:41 PM, Stephen Neuendorffer
<stephen.neuendorffer@gmail.com> wrote:
>
>
> On Fri, Apr 17, 2009 at 10:49 PM, Grant Likely <grant.likely@secretlab.ca>
> wrote:
>>
>> On Fri, Apr 17, 2009 at 11:06 AM, Stephen Neuendorffer
>> <stephen.neuendorffer@xilinx.com> wrote:
>> >
>> > Can we have XILINX_DRIVERS, please?  That way this can also be enabled
>> > on any architecture that has FPGA peripherals.
>>
>> I've thought about this more, and I'd really rather not.  The list of
>> affected drivers is short and is not a large maintenance burden.  I
>> don't think a list of 2 or 3 architecture selects for each driver is
>> unreasonable.  A "XILINX_DRIVERS" config item doesn't really help much
>> anyway.  At any given time one of these drivers may be needed on
>> another platform.  ie. the SystemACE device is present on at least one
>> non-virtex, non-spartan platform.
>
> Which is exactly why having it architecture dependent isn't right...  All of
> these drivers
> could be needed and used on any OF-based platform.  If you have a platform
> (for instance, a processor connected to an FPGA which has these peripherals
> in the FPGA) then you should be able to enable these drivers.  Just my 2
> cents...

What about the radical approach of having NO architecture
filters/selectors?  Even if some random i386 user selects one of these
drivers, so what?  It will still compile cleanly (if it doesn't we
have to fix it), but there'll be no platform_device_register() call in
their machine startup to actually cause driver / device binding.

No harm, no foul.  Problem goes away.

Then, as Grant points out, the rare cases where non-Xilinx platforms
do use this stuff, they'll presumably know what they're doing and it's
their responsibility to register the appropriate platform_device
structures and make the magic happen.

John
-- 
John Williams, PhD, B.Eng, B.IT
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
