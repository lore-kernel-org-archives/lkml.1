Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYBKWku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYBKWku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758990AbYBKWk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:40:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36944 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbYBKWkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:40:24 -0500
Date: Mon, 11 Feb 2008 23:38:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, matthew@wil.cx, arjan@infradead.org,
       hancockr@shaw.ca, torvalds@linux-foundation.org, greg@kroah.com,
       tcamuso@redhat.com, grundler@parisc-linux.org, loic@myri.com,
       bunk@kernel.org, benh@kernel.crashing.org, ink@jurassic.park.msu.ru,
       gregkh@suse.de, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-pci@atrey.karlin.mff.cuni.cz, mj@ucw.cz
Subject: Re: [PATCH] Change pci_raw_ops to pci_raw_read/write
Message-ID: <20080211223825.GB9576@elte.hu>
References: <47AB299D.4000500@redhat.com> <20080209124138.GA28967@parisc-linux.org> <86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com> <20080210072116.GA12375@kroah.com> <20080210145122.GC5299@parisc-linux.org> <86802c440802101216t3b04c0b4y89a05ac9a04a0ac5@mail.gmail.com> <alpine.LFD.1.00.0802101222560.2896@woody.linux-foundation.org> <20080210204556.GG5299@parisc-linux.org> <86802c440802101749h5af30b4dm1836f881a898652e@mail.gmail.com> <20080211141006.0aadac6c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211141006.0aadac6c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > please check some updated patches in -mm that could be affected. 
> > hope it could save you some time
> > 
> > x86-validate-against-acpi-motherboard-resources.patch
> > x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
> > x86-mmconf-enable-mcfg-early.patch
> > x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
> 
> I have unhappy feelings here - the patches seem to be churning a bit 
> and when I last sent them to Greg and Ingo they received no apparent 
> response.

i actually carried them for a while and 
validate-against-acpi-motherboard-resources.patch got a fair bit of test 
time with positive results. So it has a clear ACK from me.

It's something that looks appealing:

| This path adds validation of the MMCONFIG table against the ACPI 
| reserved motherboard resources. If the MMCONFIG table is found to be 
| reserved in ACPI, we don't bother checking the E820 table.  The PCI 
| Express firmware spec apparently tells BIOS developers that 
| reservation in ACPI is required and E820 reservation is optional, so 
| checking against ACPI first makes sense.  Many BIOSes don't reserve 
| the MMCONFIG region in E820 even though it is perfectly functional, 
| the existing check needlessly disables MMCONFIG in these cases.

anything that isolates Linux from BIOS messups should be music to our 
ears.

i also think the mmconf-enable stuff for Barcelona stuff from Yinghai, 
albeit not particularly pretty, is probably good too for similar 
reasons. It makes the kernel boot with noacpi which is a good sign IMO. 

I have testsystems that simply do not boot with ACPI turned off - and i 
have a testsystem that locks up hard if it takes an NMI in certain ACPI 
AML sequences ... Just Because.

So i'd ACK them just on general principle - earlier versions of the 
patches were carried in x86.git and caused no particular problems.

but ... then we got complaints from you that stuff collides and that 
such patches should be carried in your or Greg's tree, so we dropped 
them. And there was another 100 KLOC of x86 code to worry about ;-)

So i'd suggest to send those patches upstream, they are system enablers 
and they are at fundamental enough places to be apparent if they cause 
any breakage i think.

	Ingo
