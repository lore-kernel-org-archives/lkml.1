Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbYHEKHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbYHEKHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 06:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757773AbYHEKH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 06:07:27 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:2607 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756AbYHEKH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 06:07:26 -0400
X-Greylist: delayed 1957 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Aug 2008 06:07:26 EDT
X-Spam-Flag: NO
X-Spam-Score: -9.389
Message-ID: <48981EAB.8080302@tudelft.nl>
Date: Tue, 05 Aug 2008 11:34:35 +0200
From: Eric Piel <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.16) Gecko/20080725 Mandriva/2.0.0.16-1mdv2009.0 (2009.0) Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: sdhci: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter
 -	disabling IRQ
References: <20080624181656.GB14243@hardeman.nu> <20080710083457.7887d363@mjolnir.drzeus.cx> <20080711164706.GA8943@hardeman.nu> <20080719015531.6c8a1981@mjolnir.drzeus.cx> <20080802224725.GA6574@hardeman.nu>
In-Reply-To: <20080802224725.GA6574@hardeman.nu>
Content-Type: multipart/mixed;
 boundary="------------050205010909080105090809"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050205010909080105090809
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

David Härdeman schreef:
> On Sat, Jul 19, 2008 at 01:55:31AM +0200, Pierre Ossman wrote:
>> On Fri, 11 Jul 2008 18:47:06 +0200 David Härdeman <david@hardeman.nu> 
>> wrote:
>>> On Thu, Jul 10, 2008 at 08:34:57AM +0200, Pierre Ossman wrote:
>>> >And can you give me a complete
>>> >dmesg dump. The sdhci hardware might not be the culprit, but just a
>>> >trigger in that it enables that interrupt line.
>>>
>>> Attached below....and /proc/interrupts says:
>>>
>>
>> I see that you have an iwl4965. I got this precise problem when I
>> toggled the rfkill switch on my laptop. It is fixed in 2.6.26 though.
>> Could you try upgrading the kernel and see if it's the same bug?
> 
> Unfortunately the problem is still present with 2.6.26 (Debian package 
> linux-image-2.6.26-1-amd64):
> 
> [  640.407901] irq 19: nobody cared (try booting with the "irqpoll" option)
> [  640.407906] Pid: 0, comm: swapper Not tainted 2.6.26-1-amd64 #1
> [  640.407908] [  640.407909] Call Trace:
> [  640.407910]  <IRQ>  [<ffffffff8026c46b>] __report_bad_irq+0x30/0x72
> [  640.407937]  [<ffffffff8026c6aa>] note_interrupt+0x1fd/0x23b
> [  640.407945]  [<ffffffff8026cf33>] handle_fasteoi_irq+0xa5/0xc8
> [  640.407951]  [<ffffffff8020f590>] do_IRQ+0x6d/0xd9
> [  640.407956]  [<ffffffff8020c43d>] ret_from_intr+0x0/0x19
> [  640.407958]  <EOI>  [<ffffffff8021e480>] hpet_legacy_next_event+0x0/0x34
> [  640.407974]  [<ffffffffa002f46e>] 
> :processor:acpi_idle_enter_simple+0x18d/0x1ff
> [  640.407983]  [<ffffffff803a704c>] cpuidle_idle_call+0x7a/0xb2
> [  640.407986]  [<ffffffff803a6fd2>] cpuidle_idle_call+0x0/0xb2
> [  640.407989]  [<ffffffff8020ac79>] cpu_idle+0x89/0xb3
> [  640.408003] [  640.408004] handlers:
> [  640.408005] [<ffffffffa012e9ab>] (sdhci_irq+0x0/0x5de [sdhci])
> [  640.408010] Disabling IRQ #19
> 

Interesting, I have the same problem when I turn on my wifi and 
bluetooth (b43 + hci_usb). However, it's my firewire controller which is 
on IRQ 19. So, could it be one of those hardware components generate an 
interrupt on #19 when turned on?

irq 19: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.26-git-eric #17

Call Trace:
  <IRQ>  [<ffffffff804ca0eb>] ? _spin_unlock_irqrestore+0x1b/0x40
  [<ffffffff80283926>] __report_bad_irq+0x26/0x80
  [<ffffffff80283c1f>] note_interrupt+0x29f/0x2d0
  [<ffffffff8028450d>] handle_fasteoi_irq+0xdd/0x100
  [<ffffffff8020ff1d>] do_IRQ+0x9d/0x130
  [<ffffffff8020cbdd>] ret_from_intr+0x0/0x19
  <EOI>  [<ffffffff80223c26>] ? native_irq_enable+0x6/0x10
  [<ffffffffa01206b1>] ? :processor:acpi_idle_enter_simple+0x1e9/0x265
  [<ffffffff80422ac9>] ? cpuidle_idle_call+0xb9/0x100
  [<ffffffff80422a10>] ? cpuidle_idle_call+0x0/0x100
  [<ffffffff8020a000>] ? default_idle+0x0/0x50
  [<ffffffff8020b57c>] ? cpu_idle+0x6c/0x100
  [<ffffffff804b8d00>] ? rest_init+0x70/0x80

handlers:
[<ffffffffa0161fd0>] (ohci_irq_handler+0x0/0x8d0 [ohci1394])
Disabling IRQ #19


See you,
Eric

--------------050205010909080105090809
Content-Type: text/x-vcard; charset=utf-8;
 name="E_A_B_Piel.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="E_A_B_Piel.vcf"

begin:vcard
fn;quoted-printable:=C3=89ric Piel
n;quoted-printable:Piel;=C3=89ric
org:Technical University of Delft;Software Engineering Research Group
adr:HB 08.080;;Mekelweg 4;Delft;;2628 CD;The Netherlands
email;internet:E.A.B.Piel@tudelft.nl
tel;work:+31 15 278 6338
tel;cell:+31 6 2437 9135
x-mozilla-html:FALSE
url:http://pieleric.free.fr
version:2.1
end:vcard


--------------050205010909080105090809--
