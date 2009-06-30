Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbZF3N3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbZF3N3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 09:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZF3N3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 09:29:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:46555 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbZF3N3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 09:29:07 -0400
Date: Tue, 30 Jun 2009 06:29:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] RO/NX protection for loadable kernel modules
Message-ID: <20090630062939.4878fcbe@infradead.org>
In-Reply-To: <817ecb6f0906300611s3b21b85by54e689e073bd2012@mail.gmail.com>
References: <817ecb6f0906290816t2537e5des3b78b32c6fd16700@mail.gmail.com>
	<20090629083051.232bac68@infradead.org>
	<817ecb6f0906300611s3b21b85by54e689e073bd2012@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 09:11:33 -0400
Siarhei Liakh <sliakh.lkml@gmail.com> wrote:

> > (and one can still argue that making this an option is not even
> > worth that, and just always do it unconditional)
> >
> 
> I can make NX unconditional. However, it will not reduce the number
> of #ifdefs. There are two of them in the patch right now: one
> controls the inclusion of two extra fields (init_ro_size,
> core_ro_size) in struct module, and the other one controls the
> inclusion of ALL patch code. The *_ro_size fields are used only for
> RO, and are not used to set NX. Therefore, this #ifdef will stay even
> if NX is unconditional. Since the second #ifdef controls ALL of the
> patch's code it will also stay (to control RO part) when NX becomes
> unconditional.
> 
> Given that it will not reduce the number of #ifdefs, do you still
> think that NX should be made unconditional?

I think that not only NX should be made unconditional, I also think
that the RO code should be unconditional.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
