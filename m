Return-Path: <linux-kernel-owner+w=401wt.eu-S1760070AbYEMN3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070AbYEMN3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 09:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755633AbYEMN3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 09:29:13 -0400
Received: from gate1.informatik.fh-wiesbaden.de ([195.72.96.254]:60511 "EHLO
	gate1.informatik.fh-wiesbaden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbYEMN3M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 09:29:12 -0400
From: "Robert Kaiser (FH)" <kaiser@informatik.fh-wiesbaden.de>
Organization: Sysgo AG
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] Re: [PATCH] xen: remove support for non-PAE 32-bit
Date: Tue, 13 May 2008 15:28:08 +0200
User-Agent: KMail/1.7.2
Cc: xen-devel@lists.xensource.com, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <48243015.2010801@goop.org> <200805131332.14631.kaiser@informatik.fh-wiesbaden.de> <48298002.5080300@goop.org>
In-Reply-To: <48298002.5080300@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805131528.09429.kaiser@informatik.fh-wiesbaden.de>
X-FHW-FB06-MailScanner: Found to be clean
X-FHW-FB06-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.502,
	required 5.5, ALL_TRUSTED -2.82, COMBINED_FROM 0.32)
X-MailScanner-From: kaiser@informatik.fh-wiesbaden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 13 Mai 2008 13:48 schrieb Jeremy Fitzhardinge:
> Robert Kaiser (FH) wrote:
> > Hmm, I had to revert to non-PAE operation (using xen 3.2.1) recently in
> > order to get Xen to run under qemu. Does anyone know of another
> > work-around to run Xen/Linux under qemu?
>
> In principle it should work in PAE mode;

I thought so, too, however it doesn't :-(.

> it certainly works in kvm. 
> What problem are you seeing?

Linux crashes just after the message "Freeing unused 
kernel memory: ..." due to dereferencing a bad address.

The following is from the top of my head (if you need more details, let me kow 
and I'll recompile everything with PAE so I can reproduce the problem again 
-- this will take some time though..):

The crash results from a call to do_munmap(). Strangely though, when setting a 
breakpoint at the faulting assembly instruction (I'm using qemu's debug stub 
facility) , the problem disappears: the address being dereferenced (contained 
in register eax) is always a valid one. However, as soon as I remove that 
breakpoint and hit "continue", it does crash again with the crash dump 
showing an eip pointing to where the breakpoint formerly was, and an invalid 
address in eax.

> I think there's a bug in qemu's x86 
> emulation with respect to mis-reporting the eip of an xchg which faults,
> which may be what you're seeing.

The eip that was reported was always the same, and there was no xchg 
instruction at that address. It might have been consistently wrong though 
(how would I figure this out?).


Rob

-- 
Robert Kaiser                    http://wwwvs.informatik.fh-wiesbaden.de
Labor für Verteilte Systeme            kaiser@informatik.fh-wiesbaden.de
FH Wiesbaden - University of Applied Sciences     tel: (+49)611-9495-294
Kurt-Schumacher-Ring 18, 65197 Wiesbaden, Germany fax: (+49)611-9495-294
