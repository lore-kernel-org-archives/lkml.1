Return-Path: <linux-kernel-owner+w=401wt.eu-S1751467AbZH1JQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbZH1JQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 05:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbZH1JQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 05:16:51 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33591 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZH1JQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 05:16:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=agmLIQKDJFaz0ViIacg3fKvv7FkFYKerg/L/4mO/vqnUIRWGGWsYQGhbAjuCX+pVhV
         HYea69wsXt2H6PAQ20AUuUrh6IqHWX0wbMbZDt5Ouk9QDRQqn1rpSAx8c20bHGMj9OPS
         mo0mtulnE2/c15V2GNMXSgEJur4C+hdtz/Wgo=
Message-ID: <4A97A082.6040208@gmail.com>
Date: Fri, 28 Aug 2009 11:16:50 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.4 Thunderbird/3.0b3
MIME-Version: 1.0
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org
Subject: Re: irq 18: nobody cared after resume
References: <c4e36d110908280148p4ee31c71l4f0c0c906fe06ebe@mail.gmail.com>
In-Reply-To: <c4e36d110908280148p4ee31c71l4f0c0c906fe06ebe@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2009 10:48 AM, Zdenek Kabelac wrote:
> /proc/interrrupts:
> 18:        384        395   IO-APIC-fasteoi   uhci_hcd:usb7, mmc0
...
> HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> irq 18: nobody cared (try booting with the "irqpoll" option)
> Pid: 0, comm: swapper Not tainted 2.6.31-rc7-00059-ge716334 #19
> Call Trace:
>  <IRQ>  [<ffffffff810a500b>] __report_bad_irq+0x2b/0xa0
>  [<ffffffff810a520a>] note_interrupt+0x18a/0x1d0
>  [<ffffffff810a588d>] handle_fasteoi_irq+0xcd/0xf0
>  [<ffffffff8100ee99>] handle_irq+0x49/0xa0
>  [<ffffffff813e1343>] do_IRQ+0x73/0xf0
>  [<ffffffff8100cb93>] ret_from_intr+0x0/0xf
>  <EOI>  [<ffffffff8129057d>] ? acpi_idle_enter_c1+0xa1/0xc0
>  [<ffffffff8107d83d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff81290580>] ? acpi_idle_enter_c1+0xa4/0xc0
>  [<ffffffff8129057d>] ? acpi_idle_enter_c1+0xa1/0xc0
>  [<ffffffff81334a9b>] ? cpuidle_idle_call+0x9b/0xf0
>  [<ffffffff8100aa7b>] ? cpu_idle+0x6b/0xd0
>  [<ffffffff813c72ca>] ? rest_init+0x7a/0x80
>  [<ffffffff81601b02>] ? start_kernel+0x38f/0x39b
>  [<ffffffff81601128>] ? x86_64_start_reservations+0x125/0x129
>  [<ffffffff8160120d>] ? x86_64_start_kernel+0xe1/0xe8
> handlers:
> [<ffffffffa0006720>] (usb_hcd_irq+0x0/0xa0 [usbcore])

The interesting thing is that there is no mmc handler. So it seems like
mmc disabled the irq in kernel, but not in HW?
