Return-Path: <linux-kernel-owner+w=401wt.eu-S1946151AbXBPUoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946151AbXBPUoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946146AbXBPUoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:44:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54073 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946145AbXBPUn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:43:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [RFC] killing the NR_IRQS arrays.
Date: Fri, 16 Feb 2007 21:43:24 +0100
User-Agent: KMail/1.9.5
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com> <200702162045.58857.arnd@arndb.de> <20070216195256.GE2572@flint.arm.linux.org.uk>
In-Reply-To: <20070216195256.GE2572@flint.arm.linux.org.uk>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
X-Legal: Vorsitzender des Aufsichtsrats: Johann Weihen=0A=0D Gesch=E4ftsf=FChrung: Herbert Kircher=0A=0D Sitz der Gesellschaft: B=F6blingen=0A=0D Registergericht: Amtsgericht Stuttgart, HRB 243294
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702162143.25130.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX18+/Z1/Vd1hMWIdmIF1jrkz5AJyDZrburd8959+b15+B31wRrLzOqxyf8j/UqsqOlJXuP6FPboVem/114PwINuUEy79KKnB4GeXUpVOuqzAyA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 February 2007 20:52, Russell King wrote:
> On Fri, Feb 16, 2007 at 08:45:58PM +0100, Arnd Bergmann wrote:
> > We did something like this a few years back on the s390 architecture, which
> > happens to be lucky enough not to share any interrupt based drivers with
> > any of the other architectures.
> 
> What you're proposing is looking similar to a proposal I put forward some
> 4 years ago, but was rejected.  Maybe times have changed and there's a
> need for it now.

Yes, I think times have changed, with the increased popularity of MSI
and paravirtualized devices. A few points on your old proposal though:

- Doing it per architecture no longer sounds feasible, I think it would
  need to be done per subsystem so that the drivers can be adapted to
  a new interface, and most drivers are used across multiple architectures.
- struct irq sounds much more fitting than struct irq_desc
- creating new irq_foo() functions to replace foo_irq() also sounds right.
- I don't see the point in splitting request_irq into irq_request and
  irq_register.
- doing subsystem specific abstractions ideally allows the drivers to
  not even need to worry about the irq pointer, significantly simplifying
  the interface for register/unregister.

	Arnd <><
