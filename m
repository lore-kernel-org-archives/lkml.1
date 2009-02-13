Return-Path: <linux-kernel-owner+w=401wt.eu-S1760674AbZBMUs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760674AbZBMUs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbZBMUst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:48:49 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:54053 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbZBMUss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:48:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18837.56478.10536.6978@stoffel.org>
Date: Fri, 13 Feb 2009 15:48:30 -0500
From: "John Stoffel" <john@stoffel.org>
To: Philippe Grenard <philippe.grenard@laposte.net>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: Re: PROBLEM: cannot get stable system since 2.6.28 kernel
In-Reply-To: <200902132056.20097.philippe.grenard@laposte.net>
References: <200902131944.56634.philippe.grenard@laposte.net>
	<alpine.LFD.2.00.0902131356010.5440@localhost.localdomain>
	<200902132056.20097.philippe.grenard@laposte.net>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Philippe" == Philippe Grenard <philippe.grenard@laposte.net> writes:

Philippe> On Friday 13 February 2009 19:56:54 Len Brown wrote:
>> dmesg -- assuming you can boot far enough to capture it,
>> may be helpful.
>> 
>> also, disabling PREEMPT may be interesting to try.
>> 
>> cheers,
>> --
>> Len Brown, Intel Open Source Technology Center

Philippe> I tried to disable all "PREEMPT" options in make config, re-compiled 2.6.29-rc4 
Philippe> and managed to get these info before kernel stalls :
Philippe> (Was that what you understood by "disabling PREEMPT" ?)

Philippe> I'll also try to make some diff on the different files to
Philippe> see what changes between working 2.6.27.10 and non-working
Philippe> 2.6.29-rc4

....
Philippe> [   33.663143] input: btnx mouse as /class/input/input9
Philippe> [   36.351195] nvidia: module license 'NVIDIA' taints kernel.
Philippe> [   36.603727] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Philippe> [   36.603733] nvidia 0000:01:00.0: setting latency timer to 64
Philippe> [   36.603892] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  180.22  Tue Jan  
Philippe> 6 09:15:58 PST 2009
Philippe> [   36.606686] IRQ 16/nvidia: IRQF_DISABLED is not guaranteed on shared IRQs

Here's your problem most probably.  The nVidia graphics module.
Remove that and re-try your system.  Basically, we can't help you when
you use a vendor's binary module.

John
