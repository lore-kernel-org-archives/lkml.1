Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbXKAUdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbXKAUdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 16:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbXKAUc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 16:32:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35589 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752930AbXKAUc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 16:32:57 -0400
Date: Thu, 1 Nov 2007 13:32:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bongani Hlope <bonganilinux@mweb.co.za>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: irq 21: nobody cared 2.6.24-rc1
Message-Id: <20071101133238.16bb9a3f.akpm@linux-foundation.org>
In-Reply-To: <200710251045.37040.bonganilinux@mweb.co.za>
References: <200710251045.37040.bonganilinux@mweb.co.za>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 10:45:36 +0200
Bongani Hlope <bonganilinux@mweb.co.za> wrote:

> Booting with irqpoll works
> 
> ls /proc/irq/21/ (with irqpoll)
> ehci_hcd:usb1/  smp_affinity  uhci_hcd:usb2/  uhci_hcd:usb3/  uhci_hcd:usb4/
> 
> irq 21: nobody cared (try booting with the "irqpoll" option)
> 
>  Call Trace:
>   <IRQ>  [__report_bad_irq+56/124] __report_bad_irq+0x38/0x7c
>   <IRQ>  [<ffffffff802622eb>] __report_bad_irq+0x38/0x7c
>   [note_interrupt+546/617] note_interrupt+0x222/0x269
>   [<ffffffff80262551>] note_interrupt+0x222/0x269
>   [handle_fasteoi_irq+179/221] handle_fasteoi_irq+0xb3/0xdd
>   [<ffffffff80262bfa>] handle_fasteoi_irq+0xb3/0xdd
>   [do_IRQ+246/361] do_IRQ+0xf6/0x169
>   [<ffffffff8020e271>] do_IRQ+0xf6/0x169
>   [ret_from_intr+0/10] ret_from_intr+0x0/0xa
>   [<ffffffff8020be41>] ret_from_intr+0x0/0xa
>   <EOI>  [unmap_vmas+665/1878] unmap_vmas+0x299/0x756
>   <EOI>  [<ffffffff802728fc>] unmap_vmas+0x299/0x756
>   [unmap_vmas+1838/1878] unmap_vmas+0x72e/0x756
>   [<ffffffff80272d91>] unmap_vmas+0x72e/0x756
>   [exit_mmap+137/295] exit_mmap+0x89/0x127
>  > [<ffffffff80276592>] exit_mmap+0x89/0x127
>   [mmput+40/164] mmput+0x28/0xa4
>  [<ffffffff802314dc>] mmput+0x28/0xa4
>   [flush_old_exec+1543/2268] flush_old_exec+0x607/0x8dc
>   [<ffffffff8028fafe>] flush_old_exec+0x607/0x8dc
>   [load_elf_binary+0/7165] load_elf_binary+0x0/0x1bfd
>   [<ffffffff802bb46b>] load_elf_binary+0x0/0x1bfd
>   [load_elf_binary+0/7165] load_elf_binary+0x0/0x1bfd
>   [<ffffffff802bb46b>] load_elf_binary+0x0/0x1bfd
>   [load_elf_binary+1337/7165] load_elf_binary+0x539/0x1bfd
>   [<ffffffff802bb9a4>] load_elf_binary+0x539/0x1bfd
>   [__strnlen_user+33/45] __strnlen_user+0x21/0x2d
>   [<ffffffff80313be1>] __strnlen_user+0x21/0x2d
>   [put_arg_page+9/11] put_arg_page+0x9/0xb
>   [<ffffffff8028e81b>] put_arg_page+0x9/0xb
>   [load_elf_binary+0/7165] load_elf_binary+0x0/0x1bfd
>   [<ffffffff802bb46b>] load_elf_binary+0x0/0x1bfd
>   [search_binary_handler+227/565] search_binary_handler+0xe3/0x235
>   [<ffffffff8028ec71>] search_binary_handler+0xe3/0x235
>   [do_execve+357/451] do_execve+0x165/0x1c3
>   [<ffffffff80290293>] do_execve+0x165/0x1c3
>   [sys_execve+54/145] sys_execve+0x36/0x91
>   [<ffffffff8020a42f>] sys_execve+0x36/0x91
>   [stub_execve+103/176] stub_execve+0x67/0xb0
>   [<ffffffff8020bcf7>] stub_execve+0x67/0xb0
> 
>  handlers:
>  [_end+128171676/2130295572] (usb_hcd_irq+0x0/0x5d [usbcore])
>  [<ffffffff880a0388>] (usb_hcd_irq+0x0/0x5d [usbcore])
>  [_end+128171676/2130295572] (usb_hcd_irq+0x0/0x5d [usbcore])
>  [<ffffffff880a0388>] (usb_hcd_irq+0x0/0x5d [usbcore])
>  [_end+128171676/2130295572] (usb_hcd_irq+0x0/0x5d [usbcore])
>  [<ffffffff880a0388>] (usb_hcd_irq+0x0/0x5d [usbcore])
>  [_end+128171676/2130295572] (usb_hcd_irq+0x0/0x5d [usbcore])
>  [<ffffffff880a0388>] (usb_hcd_irq+0x0/0x5d [usbcore])
>  Disabling IRQ #21
> 

Was any earlier kernel version OK?  2.6.23?
