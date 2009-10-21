Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbZJUSAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbZJUSAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 14:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbZJUSAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 14:00:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:50070 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbZJUSAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 14:00:05 -0400
Date: Wed, 21 Oct 2009 11:00:53 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, esandeen@redhat.com,
       cebbert@redhat.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Unnecessary overhead with stack protector.
Message-ID: <20091021110053.26ab9982@infradead.org>
In-Reply-To: <4ADF2DAA.9030604@redhat.com>
References: <20091015183540.GA8098@redhat.com>
	<20091015190720.GA19467@elte.hu>
	<4ADF2DAA.9030604@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009 10:50:02 -0500
Eric Sandeen <sandeen@redhat.com> wrote:

> Ingo Molnar wrote:
> > (Cc:-ed Arjan too.)
> > 
> > * Dave Jones <davej@redhat.com> wrote:
> > 
> >> 113c5413cf9051cc50b88befdc42e3402bb92115 introduced a change that
> >> made CC_STACKPROTECTOR_ALL not-selectable if someone enables 
> >> CC_STACKPROTECTOR.
> >>
> >> We've noticed in Fedora that this has introduced noticable
> >> overhead on some functions, including those which don't even have
> >> any on-stack variables.
> >>
> >> According to the gcc manpage, -fstack-protector will protect
> >> functions with as little as 8 bytes of stack usage. So we're
> >> introducing a huge amount of overhead, to close a small amount of
> >> vulnerability (the >0 && <8 case).
> >>
> >> The overhead as it stands right now means this whole option is 
> >> unusable for a distro kernel without reverting the above commit.
> > 
> > Exactly what workload showed overhead, and how much?
> > 
> > 	Ingo
> 
> I had xfs blowing up pretty nicely; granted, xfs is not svelte but it
> was never this bad before.
> 

do you have any indication that SP actually increases the stack
footprint by that much? it's only a few bytes....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
