Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbYCaBH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbYCaBH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 21:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbYCaBHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 21:07:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422AbYCaBHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 21:07:15 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: linux1394-devel@lists.sourceforge.net
Subject: Re: nobody cared about IRQ 19 (firewire, on a HP 2510p notebook)
Date: Sun, 30 Mar 2008 21:06:41 -0400
User-Agent: KMail/1.9.9
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Martin Michlmayr <tbm@cyrius.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20080321153952.GA26354@deprecation.cyrius.com> <20080330161339.GC28821@deprecation.cyrius.com> <47EFD09D.3020906@s5r6.in-berlin.de>
In-Reply-To: <47EFD09D.3020906@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803302106.42624.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 March 2008 01:40:45 pm Stefan Richter wrote:
> Martin Michlmayr wrote:
> > * Stefan Richter <stefanr@s5r6.in-berlin.de> [2008-03-30 13:11]:
> >> Martin, please check whether the same happens if you disable
> >> firewire-ohci in the kernel config (or blacklist it in the modprobe
> >> config) and use the ohci1394 driver instead.
> >
> > Yes, I get essentially the same message with the ohci1394 driver:
> >
> > [  895.455783] irq 19: nobody cared (try booting with the "irqpoll"
> > option) [  895.455783] Pid: 0, comm: swapper Not tainted 2.6.25-rc7-amd64
> > #1 [  895.455783]
> > [  895.455783] Call Trace:
> > [  895.455783]  <IRQ>  [<ffffffff88078155>]
> > :ohci1394:ohci_irq_handler+0x4b/0x76e [  895.455783] 
> > [<ffffffff8026c883>] __report_bad_irq+0x30/0x72
> > [  895.455783]  [<ffffffff8026cac2>] note_interrupt+0x1fd/0x23f
> > [  895.455783]  [<ffffffff8026d34f>] handle_fasteoi_irq+0xa5/0xc8
> > [  895.455783]  [<ffffffff8020f53c>] do_IRQ+0x6d/0xd9
> > [  895.455783]  [<ffffffff8020c46d>] ret_from_intr+0x0/0x19
> > [  895.455783]  <EOI>  [<ffffffff803a25a4>] menu_reflect+0x0/0x75
> > [  895.455783]  [<ffffffff8800642b>]
> > :processor:acpi_idle_enter_simple+0x18d/0x1fe [  895.455783] 
> > [<ffffffff803a1b2b>] cpuidle_idle_call+0x7a/0xb3 [  895.455783] 
> > [<ffffffff803a1ab1>] cpuidle_idle_call+0x0/0xb3
> > [  895.455783]  [<ffffffff8020b06c>] cpu_idle+0xa9/0xd3
> > [  895.455783]
> > [  895.455783] handlers:
> > [  895.455783] [<ffffffff8807810a>] (ohci_irq_handler+0x0/0x76e
> > [ohci1394]) [  895.455783] Disabling IRQ #19
> >
> > dmesg is attached.
>
> Thanks.
>
> I tend to believe it is a problem to be addressed in the x86 platform
> support, not a driver problem.
>
> I Cc'd some random x86 folk...  To rehash the issue:
>
>    - Controller: Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 04)
>      Board: PM965/GM965/GL960 based
>      The R5C832 is known to work with ohci1394 according to
>      http://hardware4linux.info/component/14348/ and other reports.

Its also known to work with the juju firewire stack -- that's the controller 
in my own laptop, as well as a few other folks here in the office, all 
running the new stack.



-- 
Jarod Wilson
jwilson@redhat.com
