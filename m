Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbZIDOMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbZIDOMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 10:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbZIDOMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 10:12:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:40160 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829AbZIDOMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 10:12:45 -0400
Date: Fri, 4 Sep 2009 07:15:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       jeremy.fitzhardinge@citrix.com, stable@kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [tip:x86/asm] x86/i386: Make sure stack-protector segment base
 is cache aligned
Message-ID: <20090904071524.0a7267ce@infradead.org>
In-Reply-To: <20090903211805.GB12566@elte.hu>
References: <4AA01893.6000507@goop.org>
	<tip-1ea0d14e480c245683927eecc03a70faf06e80c8@git.kernel.org>
	<4AA02687.9080406@zytor.com>
	<4AA02B02.7080101@goop.org>
	<4AA031DE.2070109@zytor.com>
	<20090903211805.GB12566@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Sep 2009 23:18:05 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > On 09/03/2009 01:45 PM, Jeremy Fitzhardinge wrote:
> > > 
> > > Two problems:
> > > 
> > >     * gcc generates %gs: references for stack-protector, but we
> > > use %fs for percpu data (because restoring %fs is faster if it's
> > > a null selector; TLS uses %gs).  I guess we could use %fs if
> > >       !CONFIG_CC_STACKPROTECTOR, or %gs if we are using it
> > > (though that has some fiddly ramifications for things like
> > > ptrace).
> > 
> > Well, by touching two segments we're getting the worst of both 
> > worlds, so at least assuming some significant number of real-world 
> > deployments use CC_STACKPROTECTOR, we really don't want to 
> > pessimize that case too much.
> 
> Fedora has stackprotector enabled so it's used in a widespread way.
> 
> 	Ingo

the other issue is that afaik we want the kernel to use the other
register than userspace does...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
