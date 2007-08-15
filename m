Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbXHOPmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbXHOPmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 11:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757170AbXHOPmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 11:42:37 -0400
Received: from mail.suse.de ([195.135.220.2]:48894 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbXHOPmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 11:42:36 -0400
Date: Wed, 15 Aug 2007 18:36:40 +0200
From: Andi Kleen <ak@suse.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <glommer@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>, kiran@scalemp.com,
       shai@scalemp.com
Subject: Re: [PATCH 3/25][V3] irq_flags / halt routines
Message-ID: <20070815163640.GJ3406@bingen.suse.de>
References: <11871821854176-git-send-email-gcosta@redhat.com> <1187182197314-git-send-email-gcosta@redhat.com> <11871822062386-git-send-email-gcosta@redhat.com> <11871822163867-git-send-email-gcosta@redhat.com> <20070815135554.GE3406@bingen.suse.de> <5d6222a80708150718v14f26343q7467385e7919fa76@mail.gmail.com> <20070815154243.GH3406@bingen.suse.de> <46C31736.2050001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C31736.2050001@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 12:09:42PM -0300, Glauber de Oliveira Costa wrote:
> Again, this is the code of such function:
> 
> static inline int raw_irqs_disabled_flags(unsigned long flags)
> {
>         return !(flags & X86_EFLAGS_IF);
> }
> so all it is doing is getting a parameter (flags), and bitmasking it. It 
> is not talking to any hypervisor. I can't see your point. Unless you are
> arguing that it _should_ be talking to a hypervisor. Is that your point?

vSMP is a hypervisor based architecture. For some reason that is not
100% clear to me, but Kiran or Shai can probably explain, it needs this 
additional bit in EFLAGS when interrupts are disabled. That gives
it some hints and then it goes somehow faster. That is clearly
paravirtualization.

Since paravirtops is designed to handle such hooks cleanly I request
that you move vSMP over to it or work with the vSMP maintainers to 
do that. Otherwise we have two different ways to do paravirtualization 
which is wrong.

-Andi
