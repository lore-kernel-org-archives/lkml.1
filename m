Return-Path: <linux-kernel-owner+w=401wt.eu-S1764209AbYBHRXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764209AbYBHRXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759476AbYBHRXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:23:19 -0500
Received: from blaine.gmane.org ([80.91.229.8]:47840 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758904AbYBHRXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:23:17 -0500
X-Greylist: delayed 1694 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2008 12:23:17 EST
To: Ingo Molnar <public-mingo-X9Un+BFzKDI@hugh.gmane.org>
Cc: Neil Horman 
	<public-nhorman-2XuSBdqkA4R54TAoqtyWWQ@hugh.gmane.org>,
       public-kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@hugh.gmane.org,
       public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
       public-mingo-H+wXaHxf7aLQT0dZR+AlfA@hugh.gmane.org,
       "Eric W. Biederman" 
	<public-ebiederm-aS9lmoZGLiVWk0Htik3J/w@hugh.gmane.org>,
       "H. Peter Anvin" <public-hpa-YMNOUZJC4hwAvxtiuMwx3w@hugh.gmane.org>,
       public-tglx-hfZtesqFncYOwBW4kG4KsQ@hugh.gmane.org,
       Vivek Goyal <public-vgoyal-H+wXaHxf7aLQT0dZR+AlfA@hugh.gmane.org>
Subject: Re: [PATCH], issue EOI to APIC prior to calling crash_kexec in die_nmi path
From: Andi Kleen <andi@firstfloor.org>
References: <20080206192555.GA24910@hmsendeavour.rdu.redhat.com>
	<20080206220001.GA15155@elte.hu> <20080206224805.GD11886@redhat.com>
	<47AA3B16.7000507@zytor.com> <20080206233657.GB12393@elte.hu>
	<m1r6fpd2uo.fsf@ebiederm.dsl.xmission.com>
	<20080207121719.GA29279@hmsreliant.think-freely.org>
	<20080207122404.GA8195@elte.hu>
Date: Fri, 08 Feb 2008 17:54:29 +0100
In-Reply-To: <20080207122404.GA8195@elte.hu> (Ingo Molnar's message of "Thu\, 7 Feb 2008 13\:24\:04 +0100")
Message-ID: <p73ir0z2xtm.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org> writes:
>
> try a dummy iret, something like:
>
>   asm volatile ("pushf; push $1f; iret; 1: \n");
>
> to get the CPU out of its 'nested NMI' state. (totally untested)

Just if you do this while running on the NMI stack (and I think
you do if you insert it at the same place as Neil's original patch)
and another NMI happens for some reason you will be dead
because your stack will corrupt.

If you really want nested NMIs you would need to fix up the NMI
stacks first by pointing them below your own stack.

-Andi

