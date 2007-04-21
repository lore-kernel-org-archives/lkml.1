Return-Path: <linux-kernel-owner+w=401wt.eu-S1751311AbXDUFcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbXDUFcM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 01:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbXDUFcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 01:32:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbXDUFcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 01:32:11 -0400
Message-ID: <4629A1BA.1020400@redhat.com>
Date: Sat, 21 Apr 2007 01:31:38 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Jesse Barnes <jesse.barnes@intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       Adam Jackson <ajackson@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: PCI bridge range sizing bug
References: <1175812632.17147.12.camel@localhost.localdomain> <200704200932.52181.jesse.barnes@intel.com> <alpine.LFD.0.98.0704201102000.9964@woody.linux-foundation.org> <200704201334.56802.jesse.barnes@intel.com>
In-Reply-To: <200704201334.56802.jesse.barnes@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Friday, April 20, 2007 11:28 am Linus Torvalds wrote:
>> On Fri, 20 Apr 2007, Jesse Barnes wrote:
>>> Sounds good, hopefully reassigning the bridge resources won't cause
>>> too much trouble.  Do you have time to hack this up?  If not, I
>>> could give it a try, as long as ajax is willing to test...
>> Actually, I would suggest we not do it automatically (because the
>> need for it is just so low, and the downsides are potentially huge -
>> there are just too many resources that are "hidden" from us through
>> ACPI tricks and having hardware that doesn't actually expose their
>> PCI resources fully through the normal PCI resource setup).
> 
> Yeah, that's probably prudent.  OTOH we should probably let the user 
> know in no uncertain terms that some of the stuff behind one of their 
> bridges will be inaccessible.

Something like that would have made it a lot more obvious
why my Matrox PCIe x1 video card will not work in my Dell
9150, while a PCI video card does work.

The PCI video card directly sits on the bus, and gets its
resources assigned by the BIOS.

The PCIe video card turned out to be a PCIe to AGP bridge,
and the BIOS did not assign the needed PCI resources, making
the system crash when I started X.

X seemed to have some trouble reading the ROM, too...

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
