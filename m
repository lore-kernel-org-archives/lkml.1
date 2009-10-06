Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbZJFKym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbZJFKym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 06:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907AbZJFKyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 06:54:41 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:55543 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbZJFKyk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 06:54:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Tvu4dYCKQnErFFSOMz2sIWEqHE6IuGzNrypEZ2BAvwnR3IKqiezm6sFC4fQ0oGIy0B
         n8HQtE10VDkTHkAqp4aF4y6TQW2hR8QDvTxE5JaKNmVDyuIZZUKP0N7bBixNZUppTR/M
         DCaFSsG+EszeIeR6XUqS4urCXnrL+LKt4e5VU=
MIME-Version: 1.0
In-Reply-To: <1254780056.8066.6.camel@dwillia2-linux.ch.intel.com>
References: <a4423d670910020246n1e82644bud8b7a01d49b93e26@mail.gmail.com>
	 <1254780056.8066.6.camel@dwillia2-linux.ch.intel.com>
Date: Tue, 6 Oct 2009 14:54:02 +0400
Message-ID: <a4423d670910060354j30be25car1aa966f23639e150@mail.gmail.com>
Subject: Re: 2.6.32-rc2: Intel(R) I/OAT DMA Engine init failed
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/6 Dan Williams <dan.j.williams@intel.com>:
> On Fri, 2009-10-02 at 02:46 -0700, Alexander Beregalov wrote:
>> Hi
>> The kerneil is 2.6.32-rc2-00196-g0efe5e3.
>> Should I bisect?
>>
>> ioatdma: Intel(R) QuickData Technology Driver 4.00
>> ioatdma 0000:00:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>> ioatdma 0000:00:08.0: setting latency timer to 64
>>   alloc irq_desc for 33 on node -1
>>   alloc kstat_irqs on node -1
>> ioatdma 0000:00:08.0: irq 33 for MSI/MSI-X
>> ioatdma 0000:00:08.0: Self-test copy timed out, disabling
>> ioatdma 0000:00:08.0: Intel(R) I/OAT DMA Engine init failed
>
> I may ask for a bisect later, but for now let's try and see why it is
> failing.  It is something platform specific as 2.6.32-rc3 loads fine on
> my v1.2 platform.  Please reproduce this with the patch below.

I can't reproduce it with you patch
(do not see "Self-test copy timed out" line):


ioatdma: Intel(R) QuickData Technology Driver 4.00
ioatdma 0000:00:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ioatdma 0000:00:08.0: setting latency timer to 64
ioatdma 0000:00:08.0: ioat1_enumerate_channels: xfercap = 4096
ioatdma 0000:00:08.0: irq 33 for MSI/MSI-X
ioatdma 0000:00:08.0: ioat1_dma_get_next_descriptor: allocated: 0
ioatdma 0000:00:08.0: desc[0]: (0x36b6b000->0x0) cookie: 0 flags: 0x2
ctl: 0x29 (op: 0 int_en: 1 compl: 1)
ioatdma 0000:00:08.0: ioat1_dma_alloc_chan_resources: allocated 256 descriptors
ioatdma 0000:00:08.0: ioat1_dma_get_next_descriptor: allocated: 1
ioatdma 0000:00:08.0: desc[1]: (0x36b6b040->0x0) cookie: 0 flags: 0x31
ctl: 0x9 (op: 0 int_en: 1 compl: 1)
ioatdma 0000:00:08.0: ioat1_tx_submit: cookie: 1
ioatdma 0000:00:08.0: ioat_get_current_completion: phys_complete: 0x36b6b000
ioatdma 0000:00:08.0: desc[0]: (0x36b6b000->0x36b6b040) cookie: 0
flags: 0x2 ctl: 0x29 (op: 0 int_en: 1 compl: 1)
ioatdma 0000:00:08.0: desc[1]: (0x36b6b040->0x0) cookie: 1 flags: 0x33
ctl: 0x9 (op: 0 int_en: 1 compl: 1)
ioatdma 0000:00:08.0: __ioat1_dma_memcpy_issue_pending: pending: 1
ioatdma 0000:00:08.0: ioat_get_current_completion: phys_complete: 0x36b6b040
ioatdma 0000:00:08.0: ioat1_timer_event: state: 1
ioatdma 0000:00:08.0: __cleanup: phys_complete: 36b6b040
ioatdma 0000:00:08.0: desc[0]: (0x36b6b000->0x36b6b040) cookie: 0
flags: 0x2 ctl: 0x29 (op: 0 int_en: 1 compl: 1)
ioatdma 0000:00:08.0: desc[1]: (0x36b6b040->0x0) cookie: 1 flags: 0x33
ctl: 0x9 (op: 0 int_en: 1 compl: 1)
ioatdma 0000:00:08.0: __cleanup cancel completion timeout
ioatdma 0000:00:08.0: ioat_get_current_completion: phys_complete: 0x36b6b040
ioatdma 0000:00:08.0: ioat1_dma_free_chan_resources: freeing 1 from used list
ioatdma 0000:00:08.0: desc[1]: (0x36b6b040->0x0) cookie: 0 flags: 0x33
ctl: 0x9 (op: 0 int_en: 1 compl: 1)
ioatdma 0000:00:08.0: DCA is disabled in BIOS
ioatdma 0000:00:08.0: ioat1_dma_get_next_descriptor: allocated: 0
ioatdma 0000:00:08.0: desc[0]: (0x36b770c0->0x0) cookie: 0 flags: 0x2
ctl: 0x29 (op: 0 int_en: 1 compl: 1)
ioatdma 0000:00:08.0: ioat_get_current_completion: phys_complete: 0x36b770c0
ioatdma 0000:00:08.0: __cleanup: phys_complete: 36b770c0
ioatdma 0000:00:08.0: desc[0]: (0x36b770c0->0x0) cookie: 0 flags: 0x2
ctl: 0x29 (op: 0 int_en: 1 compl: 1)
ioatdma 0000:00:08.0: __cleanup cancel completion timeout
ioatdma 0000:00:08.0: ioat1_timer_event: state: 0
ioatdma 0000:00:08.0: ioat1_dma_alloc_chan_resources: allocated 256 descriptors
ioatdma 0000:00:08.0: ioat1_dma_get_next_descriptor: allocated: 0
ioatdma 0000:00:08.0: desc[0]: (0x36b6bec0->0x0) cookie: 0 flags: 0x2
ctl: 0x29 (op: 0 int_en: 1 compl: 1)
ioatdma 0000:00:08.0: ioat_get_current_completion: phys_complete: 0x36b6bec0
ioatdma 0000:00:08.0: ioat1_dma_alloc_chan_resources: allocated 256 descriptors
ioatdma 0000:00:08.0: ioat1_dma_get_next_descriptor: allocated: 0
ioatdma 0000:00:08.0: desc[0]: (0x3609b200->0x0) cookie: 0 flags: 0x2
ctl: 0x29 (op: 0 int_en: 1 compl: 1)
ioatdma 0000:00:08.0: ioat1_dma_alloc_chan_resources: allocated 256 descriptors
ioatdma 0000:00:08.0: ioat_get_current_completion: phys_complete: 0x3609b200
ioatdma 0000:00:08.0: __cleanup: phys_complete: 3609b200
ioatdma 0000:00:08.0: desc[0]: (0x3609b200->0x0) cookie: 0 flags: 0x2
ctl: 0x29 (op: 0 int_en: 1 compl: 1)
ioatdma 0000:00:08.0: __cleanup cancel completion timeout
ioatdma 0000:00:08.0: ioat1_dma_get_next_descriptor: allocated: 0
ioatdma 0000:00:08.0: desc[0]: (0x360d3300->0x0) cookie: 0 flags: 0x2
ctl: 0x29 (op: 0 int_en: 1 compl: 1)
ioatdma 0000:00:08.0: ioat1_dma_alloc_chan_resources: allocated 256 descriptors
ioatdma 0000:00:08.0: ioat_get_current_completion: phys_complete: 0x360d3300
ioatdma 0000:00:08.0: __cleanup: phys_complete: 360d3300
ioatdma 0000:00:08.0: desc[0]: (0x360d3300->0x0) cookie: 0 flags: 0x2
ctl: 0x29 (op: 0 int_en: 1 compl: 1)
ioatdma 0000:00:08.0: __cleanup cancel completion timeout
ioatdma 0000:00:08.0: ioat1_timer_event: state: 0
ioatdma 0000:00:08.0: ioat1_timer_event: state: 0
ioatdma 0000:00:08.0: __cleanup: phys_complete: 36b6bec0
ioatdma 0000:00:08.0: desc[0]: (0x36b6bec0->0x0) cookie: 0 flags: 0x2
ctl: 0x29 (op: 0 int_en: 1 compl: 1)
ioatdma 0000:00:08.0: ioat1_timer_event: state: 0
ioatdma 0000:00:08.0: __cleanup cancel completion timeout

but when I commented DEBUG definition, it failed again:

ioatdma: Intel(R) QuickData Technology Driver 4.00
ioatdma 0000:00:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ioatdma 0000:00:08.0: setting latency timer to 64
  alloc irq_desc for 33 on node -1
  alloc kstat_irqs on node -1
ioatdma 0000:00:08.0: irq 33 for MSI/MSI-X
ioatdma 0000:00:08.0: Self-test copy timed out, disabling 0:0
ioatdma 0000:00:08.0: Intel(R) I/OAT DMA Engine init failed
ioatdma 0000:00:08.0: PCI INT A disabled
