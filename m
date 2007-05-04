Return-Path: <linux-kernel-owner+w=401wt.eu-S1031075AbXEDQNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031075AbXEDQNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031290AbXEDQNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:13:06 -0400
Received: from gw.goop.org ([64.81.55.164]:50982 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031075AbXEDQNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:13:04 -0400
Message-ID: <463B5B90.20308@goop.org>
Date: Fri, 04 May 2007 09:13:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] boot bzImages under paravirt
References: <1178283582.23670.67.camel@localhost.localdomain>	<1178283724.23670.70.camel@localhost.localdomain>	<1178284052.23670.75.camel@localhost.localdomain> <m1ps5gslfm.fsf@ebiederm.dsl.xmission.com> <463B4E12.50703@goop.org> <463B551E.8030701@zytor.com>
In-Reply-To: <463B551E.8030701@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> In 32-bit mode?  Surely you're joking, Mr. Feynman!
>   

Right, yes.

> What's worse, reloading segments here might be highly unsafe, if the
> memory previously occupied by the GDT has been overwritten.  Keep in
> mind the GDT is touched on a segment *load*, not on a segment *access*;
> in areas such as booting that can be a huge difference.
>   

Yep, suits me.  I'm happy for the code to assume that at least %cs and
%ds are sane; I guess %ss too.  We could copy %ds into %[efg]s if we
want to be sure (since I could imagine a bootloader leaving them in a
less defined state).

But if the gdt could be missing altogether, then, yes, we should not
touch them at all.

    J
