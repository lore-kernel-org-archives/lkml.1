Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbZFWUez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbZFWUez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 16:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZFWUer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 16:34:47 -0400
Received: from claw.goop.org ([74.207.240.146]:34210 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbZFWUeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 16:34:46 -0400
Message-ID: <4A413C66.5010306@goop.org>
Date: Tue, 23 Jun 2009 13:34:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
       linux-arch@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Tony Luck <tony.luck@intel.com>, Russell King <linux@arm.linux.org.uk>,
       Arnd Bergmann <arnd@arndb.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       Avi Kivity <avi@redhat.com>, Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [PATCH] PCI: remove pcibios_scan_all_fns()
References: <20090622140807.25509.54448.stgit@bob.kio> <20090622143431.GT19977@parisc-linux.org> <4A3FCB68.3030004@goop.org> <20090622183056.GY19977@parisc-linux.org> <1245714008.4017.7.camel@pasglop> <20090623190826.GJ19977@parisc-linux.org>
In-Reply-To: <20090623190826.GJ19977@parisc-linux.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/09 12:08, Matthew Wilcox wrote:
> I think simply materialising them, either the way the OF code does,
> or the way the IOV code does is the best route forwards.
>   

On reflection, I think this will work.  We have a Xen pci passthrough
driver which gets told about the passed-through devices via xenbus, and
does the appropriate setup.  At first glance, there doesn't seem to be
any problem with that code just explicitly instantiate the devices at
the PCI level in the same way pci_scan_device does (ie,
alloc_pci_device, initalize the dev struct, pci_setup_device).

Is that what you mean?

IanC has looked at that code more closely, so perhaps he can confirm
that this will work on our side.

    J
