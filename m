Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYH3ULF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYH3ULF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 16:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbYH3UKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 16:10:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:52341 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbYH3UKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 16:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JVuNnNWR7o4RmE0Q80Oj/qynzX+Ij4vFyulrCJATqKCGy1IhlZNn/XNlAntidk5UhH
         AJF5ZYdNSYa+gyWe7IzTnQMeyL5OrLnDHuTdSbI44kd1VNAx3uSu7H/SfVNAao1H5vjP
         wGUgj49yIVqGerssC+1SxbGyvCNcuQ7YQREdg=
Message-ID: <86802c440808301310v439344a5k2e5a1ce1ed9b0be@mail.gmail.com>
Date: Sat, 30 Aug 2008 13:10:52 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <200808302151.43092.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <86802c440808301111i2880a13eq61155b8c7b1ed3dd@mail.gmail.com>
	 <86802c440808301206u2407b77dx6c7119bc398f9529@mail.gmail.com>
	 <200808302151.43092.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 12:51 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, 30 of August 2008, Yinghai Lu wrote:
>> On Sat, Aug 30, 2008 at 11:11 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> > On Sat, Aug 30, 2008 at 10:55 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> >> On Sat, Aug 30, 2008 at 10:14 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >>
>> >>>
>> >>> Could you please rebase them on top of current -git?
>> >>
>> >> please check attached quilt series based on linus tree.
>> >
>> > there is some problem with fix -v4...on one test machine.
>> >
>>
>> this one should work.
>
> dmesg -s 262144
>
> http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/dmesg-test.log
>
> cat /proc/iomem
>
> http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/iomem-test.txt

calling  pci_subsys_init+0x0/0x120
PCI: Using ACPI for IRQ routing
request_resource: root: (PCI IO) [0, ffff], new: (PCI Bus 0000:01)
[9000, 9fff] conflict 0
request_resource: root: (PCI mem) [0, ffffffffffffffff], new: (PCI Bus
0000:01) [fe700000, fe7fffff] conflict 0
request_resource: root: (PCI mem) [0, ffffffffffffffff], new: (PCI Bus
0000:01) [d8000000, dfffffff] conflict 0
request_resource: root: (PCI IO) [0, ffff], new: (PCI Bus 0000:02)
[a000, bfff] conflict 0
request_resource: root: (PCI mem) [0, ffffffffffffffff], new: (PCI Bus
0000:02) [fe800000, fe8fffff] conflict 0
request_resource: root: (PCI IO) [0, ffff], new: (PCI Bus 0000:03)
[c000, cfff] conflict 0
request_resource: root: (PCI mem) [0, ffffffffffffffff], new: (PCI Bus
0000:03) [fe900000, fe9fffff] conflict 0
request_resource: root: (PCI IO) [0, ffff], new: (PCI Bus 0000:04)
[d000, efff] conflict 0
request_resource: root: (PCI mem) [0, ffffffffffffffff], new: (PCI Bus
0000:04) [fea00000, feafffff] conflict 0
request_resource: root: (PCI mem) [0, ffffffffffffffff], new: (PCI Bus
0000:05) [feb00000, febfffff] conflict 0
request_resource: root: (PCI mem) [0, ffffffffffffffff], new:
(0000:00:00.0) [e0000000, ffffffff] conflict 1
pci 0000:00:00.0: BAR 3: can't allocate resource

so pci_resource_survey is depth first. sub buses request some resource
at first...

we don't need quirk to handle that strange BAR res.

and we got reserved register correctly
in /proc/iomem
d7fe0000-d7ffffff : reserved
..
fff00000-ffffffff : reserved

for
 BIOS-e820: 00000000d7fe0000 - 00000000d8000000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)

YH
