Return-Path: <linux-kernel-owner+w=401wt.eu-S1759539AbXELSgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759539AbXELSgh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbXELSgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:36:31 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41904 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbXELSga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:36:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>, Matt Domsch <Matt_Domsch@dell.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPar>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
References: <464158E9.2000207@zytor.com>
	<1178806235.18785.1189115515@webmail.messagingengine.com>
	<46435F8A.1040203@zytor.com> <20070510220406.GA21110@mailshack.com>
	<4643A128.30302@zytor.com> <20070512122137.GA25944@mailshack.com>
	<m1r6pmqg1n.fsf@ebiederm.dsl.xmission.com>
	<464602DC.4050603@zytor.com>
Date: Sat, 12 May 2007 12:35:28 -0600
In-Reply-To: <464602DC.4050603@zytor.com> (H. Peter Anvin's message of "Sat,
	12 May 2007 11:09:32 -0700")
Message-ID: <m1mz09ritr.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>> 
>> HPA is both right and wrong on this.  The safe sequence for entering
>> protected mode requires a jump immediately after setting PE in %cr0.
>> To serialize the instruction stream and to be on an execution that
>> is tested and guaranteed to work in cpus.
>> 
>
> Eric, that's complete nonsense.  What Intel documents and what Intel
> tests are two very different things.

Likely.

> Intel appears to be afraid of what they call "the crack", but the
> semantics of the transition are quite well understood.

Regardless not putting a jump in there violates the principle of
be conservative in what you send.

> A lot of the Intel manuals are boilerplate written by technical writers.
>  Once you're used to them you can spot it quite easily because it's
> carried from generation to generation with little change, even when it's
> blatantly obsoleted.

Even on 386 and 486 class cpus?

To some extent if the rules don't change it makes sense for them to
copy the information from one generation to the next of the architecture.
Even if the current cpus don't really care.

I guess I just don't see the sense in taking chances if we don't have
to, and I don't see any real advantage of doing a data segment reload
before the jump.

Eric
