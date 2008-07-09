Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYGIVLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYGIVLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbYGIVLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:11:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:33660 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbYGIVLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:11:25 -0400
Date: Wed, 9 Jul 2008 14:10:44 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Mike Travis <travis@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
Message-ID: <20080709141044.60a0753e@infradead.org>
In-Reply-To: <m1r6a2yfip.fsf@frodo.ebiederm.org>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
	<4874F4F2.9010603@goop.org>
	<4874F7D9.5060607@linux-foundation.org>
	<4874FD52.8070000@sgi.com>
	<4874FFC4.7050505@linux-foundation.org>
	<487502FB.3090106@sgi.com>
	<487507A1.2020100@goop.org>
	<m1r6a2yfip.fsf@frodo.ebiederm.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008 13:22:06 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Jeremy Fitzhardinge <jeremy@goop.org> writes:
> 
> > It's just the stack canary.  It isn't library accesses; it's the
> > code gcc generates:
> >
> > foo:	subq	$152, %rsp
> >        movq    %gs:40, %rax
> >        movq    %rax, 136(%rsp)
> > ...
> >        movq    136(%rsp), %rdx
> >        xorq    %gs:40, %rdx
> >        je      .L3
> >        call    __stack_chk_fail
> > .L3:
> >        addq    $152, %rsp
> >        .p2align 4,,4
> >        ret
> >
> >
> > There are two irritating things here:
> >
> > One is that the kernel supports -fstack-protector for x86-64, which
> > forces us into all these contortions in the first place.  We don't
> > support stack-protector for 32-bit (gcc does), and things are much
> > easier.
> 
> How does gcc know to use %gs instead of the usual %fs for accessing
> the stack protector variable?  My older gcc-4.1.x on ubuntu always
> uses %fs.

ubuntu broke gcc (they don't want to have compiler flags per package so
patches stuff in gcc instead).


> I think the unification is valid and useful, and that trying to keep
> that stupid stack canary working is currently more trouble then it is
> worth.

I think that "unification over everything" is stupid, especially if it
removes useful features.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
