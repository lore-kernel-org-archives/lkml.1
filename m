Return-Path: <linux-kernel-owner+w=401wt.eu-S1764152AbYA2PQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764152AbYA2PQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 10:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbYA2PQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 10:16:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841AbYA2PQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 10:16:49 -0500
Message-ID: <479F4321.6030106@redhat.com>
Date: Tue, 29 Jan 2008 10:15:45 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <20080114225225.GQ18741@parisc-linux.org>	<20080114230448.GL9847@does.not.exist>	<478CD8A5.5090608@myri.com>	<20080115174643.GB28238@kroah.com>	<20080115175641.GE18741@parisc-linux.org>	<20080119165809.GB11553@colo.lackof.org>	<479E1FA6.1030708@redhat.com>	<20080128204431.GA15227@kroah.com>	<20080128190505.5f5b1ccc@laptopd505.fenrus.org>	<20080129031804.GF20198@parisc-linux.org>	<20080129131955.GC10761@kroah.com>	<479F34E6.40806@redhat.com> <20080129064724.0f7e91e5@laptopd505.fenrus.org>
In-Reply-To: <20080129064724.0f7e91e5@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 29 Jan 2008 09:15:02 -0500
> Tony Camuso <tcamuso@redhat.com> wrote:
> 
>> Greg,
>>
>> The problem with Arjan's patch, if I understand it correctly, is that
>> it requires drivers to make a call to access extended PCI config
>> space.
>>
>> And, IIRC, Arjan's patch encumbers drivers for all arch's, even those
>> that have no MMCONFIG problems.
>>
>> The patches proposed by Loic, Ivan, Matthew, and myself, all address
>> the problem in an x86-specific manner that is transparent to the
>> drivers.
> 
> this is not quite correct; the patches from Loic, Ivan, Matthew and you are for a different
> problem statement.
> 
> Your patch problem statement is "need to fix mmconfig", my patch problem statement is "need
> to not make users who don't need it suffer". These are orthogonal problems.
> 
> 

Yes, but your patch also makes users who need extended PCI config space suffer.

Right now, that isn't a lot of people in x86 land, but your patch encumbers drivers
for non-x86 archs with an additional call to access space that they've never had
a problem with.

As more PCI express drivers start to take advantage of AER and other advanced
express capabilities, the extra call to address a condition specific to legacy
x86 hardware is, IMNSHO, a kludge.

The patches submitted by the others fix the problems with MMCONFIG without
encumbering the drivers to be aware of any difference between legacy config
space and extended config space.

I have tested these patches on a number of systems exhibiting various MMCONFIG-
related pathologies, and they work.




