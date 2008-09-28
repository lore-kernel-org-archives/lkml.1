Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbYI1VYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbYI1VYd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 17:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbYI1VYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 17:24:25 -0400
Received: from smtp122.rog.mail.re2.yahoo.com ([206.190.53.27]:42242 "HELO
	smtp122.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751107AbYI1VYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 17:24:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gLUH+KtvAiXtQc9e2nm4GBd0Gx6Hhl2ja7Mc9WulRzY0C8ZbtHSPwUxjS/hAA3gNYKqy9xhW3pFRxYmSPLgos3ZB5wFbTuaDzKOnMinSps3LMGmjrwKPWVb/xR5oGf45NmAAPgrpAuK6CpQmC8P7F2jhKvuxzI3+jz9h+sOKQrU=  ;
X-YMail-OSG: KNGBCNQVM1mFHtMOpGkbyseuI2OJ98qPaKBLFCTLacMMS2FUbfYpTZWmFYXPovY28g--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [2.6.27-rc7-git1] (Fedora) - ACPI instabilities and IRQs being disabled
Date: Sun, 28 Sep 2008 17:24:14 -0400
User-Agent: KMail/1.10.90 (Linux/2.6.27-0.352.rc7.git1.fc10.i686; KDE/4.1.68; i686; svn-865192; 2008-09-25)
References: <200809271840.24699.shawn.starr@rogers.com>
In-Reply-To: <200809271840.24699.shawn.starr@rogers.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809281724.16408.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 September 2008 18:40:24 Shawn Starr wrote:

I believe 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=de85422b94ddb23c021126815ea49414047c13dc

is causing this regression. Can someone confirm this to be the case? It 
certainly looks suspicious given the handler lines showing this exact sort of 
code path...

Thanks, 
Shawn.

> Hello, I don't know if anyone else has been experiencing ACPI disable IRQs
> (specifically IRQ 9) but there seems to be a serious regression recently
> which causes me grief:
>
> I note, I do use VirtualBox, but unless it's somehow causing the usb
> hub/yenta socket or e1000 devices to go haywire, I would discount it's
> relation to this.  If you think otherwise, I can certainly disable it.
>
> System: IBM ThinkPad T42:
>
> /proc/interrupts:
>
>            CPU0
>   0:     405391    XT-PIC-XT        timer
>   1:       7178    XT-PIC-XT        i8042
>   2:          0    XT-PIC-XT        cascade
>   3:          1    XT-PIC-XT        ehci_hcd:usb1
>   4:         18    XT-PIC-XT        serial
>   5:        145    XT-PIC-XT        yenta, Intel 82801DB-ICH4 Modem, Intel
> 82801DB-ICH4 6:          3    XT-PIC-XT
>   7:          0    XT-PIC-XT        parport0
>   8:          1    XT-PIC-XT        rtc0
>   9:       4336    XT-PIC-XT        acpi, uhci_hcd:usb2, yenta, eth0 
> <--------------------- 10:          1    XT-PIC-XT        uhci_hcd:usb4
>  11:          1    XT-PIC-XT        uhci_hcd:usb3
>  12:     154035    XT-PIC-XT        i8042
>  14:      27629    XT-PIC-XT        ata_piix
>  15:      12342    XT-PIC-XT        ata_piix
> NMI:          0   Non-maskable interrupts
> LOC:          0   Local timer interrupts
> RES:          0   Rescheduling interrupts
> CAL:          0   function call interrupts
> TLB:          0   TLB shootdowns
> TRM:          0   Thermal event interrupts
> SPU:          0   Spurious interrupts
> ERR:          0
> MIS:          0
>
> Here's the stack dump:
>
> Sep 27 18:04:22 segfault kernel: [ 5545.784573] irq 9: nobody cared (try
> booting with the "irqpoll" option) Sep 27 18:04:22 segfault kernel: [
> 5545.784604] Pid: 87, comm: kacpid Not tainted
> 2.6.27-0.352.rc7.git1.fc10.i686 #1 Sep 27 18:04:22 segfault kernel: [
> 5545.784621]  [<c046da96>] __report_bad_irq+0x33/0x74 Sep 27 18:04:22
> segfault kernel: [ 5545.784666]  [<c046dca6>] note_interrupt+0x1cf/0x221
> Sep 27 18:04:22 segfault kernel: [ 5545.784681]  [<c044b419>] ?
> trace_hardirqs_off+0xb/0xd Sep 27 18:04:22 segfault kernel: [ 5545.784698] 
> [<c046d1bf>] ? handle_IRQ_event+0x4c/0x54 Sep 27 18:04:22 segfault kernel:
> [ 5545.784715]  [<c046e34e>] handle_level_irq+0x85/0xb9 Sep 27 18:04:22
> segfault kernel: [ 5545.784730]  [<c046e2c9>] ? handle_level_irq+0x0/0xb9
> Sep 27 18:04:22 segfault kernel: [ 5545.784747]  [<c0406fad>]
> do_IRQ+0x9f/0xc9 Sep 27 18:04:22 segfault kernel: [ 5545.784763] 
> [<c0405700>] common_interrupt+0x28/0x30 Sep 27 18:04:22 segfault kernel: [
> 5545.784779]  [<c044007b>] ? process_timer_rebalance+0x67/0x171 Sep 27
> 18:04:22 segfault kernel: [ 5545.784799]  [<c04326e8>] ?
> __do_softirq+0x6b/0x10f Sep 27 18:04:22 segfault kernel: [ 5545.784815] 
> [<c043267d>] ? __do_softirq+0x0/0x10f Sep 27 18:04:22 segfault kernel: [
> 5545.784829]  [<c0407053>] do_softirq+0x7c/0xdd Sep 27 18:04:22 segfault
> kernel: [ 5545.784842]  [<c046e2c9>] ? handle_level_irq+0x0/0xb9 Sep 27
> 18:04:22 segfault kernel: [ 5545.784859]  [<c0432340>] irq_exit+0x49/0x88
> Sep 27 18:04:22 segfault kernel: [ 5545.784874]  [<c0406fc1>]
> do_IRQ+0xb3/0xc9 Sep 27 18:04:22 segfault kernel: [ 5545.784886] 
> [<c0405700>] common_interrupt+0x28/0x30 Sep 27 18:04:22 segfault kernel: [
> 5545.784901]  [<c044007b>] ? process_timer_rebalance+0x67/0x171 Sep 27
> 18:04:22 segfault kernel: [ 5545.784918]  [<c055c815>] ?
> acpi_os_write_port+0x15/0x35 Sep 27 18:04:22 segfault kernel: [
> 5545.784936]  [<c056863c>] acpi_ex_system_io_space_handler+0x44/0x4a Sep 27
> 18:04:22 segfault kernel: [ 5545.784951]  [<c05685f8>] ?
> acpi_ex_system_io_space_handler+0x0/0x4a Sep 27 18:04:22 segfault kernel: [
> 5545.784967]  [<c0561a6d>] acpi_ev_address_space_dispatch+0x134/0x174 Sep
> 27 18:04:22 segfault kernel: [ 5545.784985]  [<c05659a3>]
> acpi_ex_access_region+0x1b7/0x1c5 Sep 27 18:04:22 segfault kernel: [
> 5545.785001]  [<c0565acd>] acpi_ex_field_datum_io+0x11c/0x1b3 Sep 27
> 18:04:22 segfault kernel: [ 5545.785016]  [<c04097a2>] ?
> native_sched_clock+0xb3/0xd3 Sep 27 18:04:22 segfault kernel: [
> 5545.785033]  [<c0565e2b>] acpi_ex_write_with_update_rule+0xda/0xe3 Sep 27
> 18:04:22 segfault kernel: [ 5545.785049]  [<c05660e8>]
> acpi_ex_insert_into_field+0x2b4/0x2d4 Sep 27 18:04:22 segfault kernel: [
> 5545.785053]  [<c05646d6>] acpi_ex_write_data_to_field+0x16e/0x186 Sep 27
> 18:04:22 segfault kernel: [ 5545.785053]  [<c057302d>] ?
> acpi_ut_allocate_object_desc_dbg+0x3e/0x6f Sep 27 18:04:22 segfault kernel:
> [ 5545.785053]  [<c05688d3>] acpi_ex_store_object_to_node+0x87/0xbc Sep 27
> 18:04:22 segfault kernel: [ 5545.785053]  [<c0568aab>]
> acpi_ex_store+0xce/0x223 Sep 27 18:04:22 segfault kernel: [ 5545.785053] 
> [<c05669ee>] acpi_ex_opcode_1A_1T_1R+0x3e0/0x53a Sep 27 18:04:22 segfault
> kernel: [ 5545.785053]  [<c056716e>] ? acpi_ex_resolve_operands+0x1d1/0x483
> Sep 27 18:04:22 segfault kernel: [ 5545.785053]  [<c055f192>]
> acpi_ds_exec_end_op+0xeb/0x379 Sep 27 18:04:22 segfault kernel: [
> 5545.785053]  [<c056defb>] acpi_ps_parse_loop+0x5d2/0x727 Sep 27 18:04:22
> segfault kernel: [ 5545.785053]  [<c056d31b>] acpi_ps_parse_aml+0x72/0x260
> Sep 27 18:04:22 segfault kernel: [ 5545.785053]  [<c056e5e7>]
> acpi_ps_execute_method+0x121/0x1da Sep 27 18:04:22 segfault kernel: [
> 5545.785053]  [<c056b797>] acpi_ns_evaluate+0x133/0x18c Sep 27 18:04:22
> segfault kernel: [ 5545.785053]  [<c056b341>]
> acpi_evaluate_object+0xe2/0x181 Sep 27 18:04:22 segfault kernel: [
> 5545.785053]  [<c0576a41>] acpi_ec_gpe_query+0x7c/0xb6 Sep 27 18:04:22
> segfault kernel: [ 5545.785053]  [<c055cdcf>]
> acpi_os_execute_deferred+0x25/0x31 Sep 27 18:04:22 segfault kernel: [
> 5545.785053]  [<c043c56a>] run_workqueue+0xdb/0x1a9 Sep 27 18:04:22
> segfault kernel: [ 5545.785053]  [<c043c525>] ? run_workqueue+0x96/0x1a9
> Sep 27 18:04:22 segfault kernel: [ 5545.785053]  [<c055cdaa>] ?
> acpi_os_execute_deferred+0x0/0x31 Sep 27 18:04:22 segfault kernel: [
> 5545.785053]  [<c043c709>] worker_thread+0xd1/0xdd Sep 27 18:04:22 segfault
> kernel: [ 5545.785053]  [<c043f922>] ? autoremove_wake_function+0x0/0x38
> Sep 27 18:04:22 segfault kernel: [ 5545.785053]  [<c043c638>] ?
> worker_thread+0x0/0xdd Sep 27 18:04:22 segfault kernel: [ 5545.785053] 
> [<c043f670>] kthread+0x40/0x66 Sep 27 18:04:22 segfault kernel: [
> 5545.785053]  [<c043f630>] ? kthread+0x0/0x66 Sep 27 18:04:22 segfault
> kernel: [ 5545.785053]  [<c04059a3>] kernel_thread_helper+0x7/0x10 Sep 27
> 18:04:22 segfault kernel: [ 5545.785053]  ======================= Sep 27
> 18:04:22 segfault kernel: [ 5545.785053] handlers:
> Sep 27 18:04:22 segfault kernel: [ 5545.785053] [<c055c788>]
> (acpi_irq+0x0/0x28) Sep 27 18:04:22 segfault kernel: [ 5545.785053]
> [<c05ef25d>] (usb_hcd_irq+0x0/0xa8) Sep 27 18:04:22 segfault kernel: [
> 5545.785053] [<f8941264>] (yenta_interrupt+0x0/0xc3 [yenta_socket]) Sep 27
> 18:04:22 segfault kernel: [ 5545.785053] [<f899a01b>] (e1000_intr+0x0/0x13f
> [e1000]) Sep 27 18:04:22 segfault kernel: [ 5545.785053] Disabling IRQ #9
> Sep 27 18:04:22 segfault kernel: [ 5546.287788] ACPI: EC: missing
> confirmations, switch off interrupt mode.
>
> Thanks,
> Shawn.


