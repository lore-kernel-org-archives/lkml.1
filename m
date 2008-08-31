Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbYHaA1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbYHaA1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 20:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbYHaA1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 20:27:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:64925 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbYHaA1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 20:27:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=g2Yqxs3tqAYZveb9XtsGxahje8lF/9bB3gl5Sh4zSGZ6HKQ1zdcazw0SXHwbJB9wBR
         mmBSDhGyGsa67ydKQ/rY+CKCEOiWsMa1ZCNSCAkd8aD0w1hJJiNQbs41YxfZIRDxUi/F
         Dz7eZ2SkqXWJcCsVeQzS2twblL6u6+J9T/AIA=
Message-ID: <86802c440808301727k3e86c816j323eca0fb5e3f4fc@mail.gmail.com>
Date: Sat, 30 Aug 2008 17:27:01 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Jordan Crouse" <jordan.crouse@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <86802c440808301639j137ebef1r1ecadeebd351fc03@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <86802c440808301107n4561e815ldf53183c92a7bc93@mail.gmail.com>
	 <alpine.LFD.1.10.0808301141590.3290@nehalem.linux-foundation.org>
	 <86802c440808301210u6db1b4e7p4036bdc95db1a601@mail.gmail.com>
	 <alpine.LFD.1.10.0808301214310.3290@nehalem.linux-foundation.org>
	 <86802c440808301314t525d1b75r9afcc73857cf5c79@mail.gmail.com>
	 <alpine.LFD.1.10.0808301539391.3290@nehalem.linux-foundation.org>
	 <86802c440808301550s627dfcb0h7ff8971c8248703a@mail.gmail.com>
	 <alpine.LFD.1.10.0808301615450.3290@nehalem.linux-foundation.org>
	 <86802c440808301639j137ebef1r1ecadeebd351fc03@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 4:39 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Sat, Aug 30, 2008 at 4:28 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>>
>> On Sat, 30 Aug 2008, Yinghai Lu wrote:
>>>
>>> wait, THAT BAR is 64BIT capable, So kernel should assign 64bit range to it...
>>> it request_resource fails...
>>
>> I don't think we've ever done new allocations in 64 bits. Although looking
>> for it, I have to admit that I don't see what would limit us right now.
>> There used to be some paths that weren't 64-bit clean, but I think we
>> fixed all of those.
>
> would be some corner case...
>

pci_assign_unassigned_resources==>pci_bus_assign_resources==>pbus_assign_resources_sorted(struct

static void pbus_assign_resources_sorted(struct pci_bus *bus)
{
        struct pci_dev *dev;
        struct resource *res;
        struct resource_list head, *list, *tmp;
        int idx;

        head.next = NULL;
        list_for_each_entry(dev, &bus->devices, bus_list) {
                u16 class = dev->class >> 8;

                /* Don't touch classless devices or host bridges or ioapics.  */
                if (class == PCI_CLASS_NOT_DEFINED ||
                    class == PCI_CLASS_BRIDGE_HOST)
                        continue;


it skips the host bridge...

YH
