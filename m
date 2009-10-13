Return-Path: <linux-kernel-owner+w=401wt.eu-S932252AbZJMBtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbZJMBtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 21:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbZJMBtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 21:49:12 -0400
Received: from mail-vw0-f203.google.com ([209.85.212.203]:40910 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbZJMBtL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 21:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=d/AzfbKen+NL13aM0ccxKqUpncI2nCN4O9ulv8a0Z7uVK7il4JBKrpIlA6QiRbSu3H
         h7M3DNg39gIMMYZUYS24xlsZslvs2Sow2xtENP14Ihbq/vfwXiHC7kp6ZCSiQQupXdEZ
         90hNuX8s75LEian9G/MYxIKLz0x8L/nBJ9zII=
MIME-Version: 1.0
In-Reply-To: <a4423d670910060354j30be25car1aa966f23639e150@mail.gmail.com>
References: <a4423d670910020246n1e82644bud8b7a01d49b93e26@mail.gmail.com>
	 <1254780056.8066.6.camel@dwillia2-linux.ch.intel.com>
	 <a4423d670910060354j30be25car1aa966f23639e150@mail.gmail.com>
Date: Mon, 12 Oct 2009 18:48:34 -0700
X-Google-Sender-Auth: ea55568da7f35149
Message-ID: <e9c3a7c20910121848u69e0a225t1eb03c43e011ebb2@mail.gmail.com>
Subject: Re: 2.6.32-rc2: Intel(R) I/OAT DMA Engine init failed
From: Dan Williams <dan.j.williams@intel.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 6, 2009 at 3:54 AM, Alexander Beregalov
<a.beregalov@gmail.com> wrote:
> but when I commented DEBUG definition, it failed again:
>
> ioatdma: Intel(R) QuickData Technology Driver 4.00
> ioatdma 0000:00:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> ioatdma 0000:00:08.0: setting latency timer to 64
>  alloc irq_desc for 33 on node -1
>  alloc kstat_irqs on node -1
> ioatdma 0000:00:08.0: irq 33 for MSI/MSI-X
> ioatdma 0000:00:08.0: Self-test copy timed out, disabling 0:0
> ioatdma 0000:00:08.0: Intel(R) I/OAT DMA Engine init failed
> ioatdma 0000:00:08.0: PCI INT A disabled

Odd, it looks like neither a dma channel interrupt nor the timer fired
while this operation was in flight.  However, when you turn on debug
we see timer events firing as expected (ioat1_timer_event).  The
operation completes successfully ( dma->device_is_tx_complete returns
DMA_SUCCESS), but its not clear what is causing us to violate the
timeout.  Before bisecting can you try commit 1f6672d4?  This is the
state of the aysnc_tx.git tree before it was merged for 2.6.32.  If
that fails then a full bisect is the only recourse I can see to get
closer to root cause.

Thanks,
Dan
