Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbZFVSUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbZFVSUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZFVSU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:20:27 -0400
Received: from claw.goop.org ([74.207.240.146]:53147 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbZFVSU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:20:26 -0400
Message-ID: <4A3FCB68.3030004@goop.org>
Date: Mon, 22 Jun 2009 11:20:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
       linux-arch@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Tony Luck <tony.luck@intel.com>, Russell King <linux@arm.linux.org.uk>,
       Arnd Bergmann <arnd@arndb.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] PCI: remove pcibios_scan_all_fns()
References: <20090622140807.25509.54448.stgit@bob.kio> <20090622143431.GT19977@parisc-linux.org>
In-Reply-To: <20090622143431.GT19977@parisc-linux.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/09 07:34, Matthew Wilcox wrote:
> On Mon, Jun 22, 2009 at 08:08:07AM -0600, Alex Chiang wrote:
>   
>> This was #define'd as 0 on all platforms, so let's get rid of it.
>>
>> This change makes pci_scan_slot() slightly easier to read.
>>     
>
>   
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index f1ae247..b613cad 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -1056,8 +1056,7 @@ int pci_scan_slot(struct pci_bus *bus, int devfn)
>>  	if (dev && !dev->is_added)	/* new device? */
>>  		nr++;
>>  
>> -	if ((dev && dev->multifunction) ||
>> -	    (!dev && pcibios_scan_all_fns(bus, devfn))) {
>> +	if (dev && dev->multifunction) {
>>  		for (fn = 1; fn < 8; fn++) {
>>  			dev = pci_scan_single_device(bus, devfn + fn);
>>  			if (dev) {
>>     
>
> What a good idea.  I was just looking at making this more complicated
> (due to the ARI capability).
>
> I'd like to know what the KVM / Xen / ... people think about this.
> I don't know if they rely on function 5 being able to show up out of
> the blue.
>   

We want to be able to export specific functions to a particular domain,
so it might see a PCI device with only function 5.

It looks like we lose that ability with this patch, is that right?

    J
