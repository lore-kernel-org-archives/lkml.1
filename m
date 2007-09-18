Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbXIRIb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbXIRIb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 04:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbXIRIbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 04:31:50 -0400
Received: from aun.it.uu.se ([130.238.12.36]:37819 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbXIRIbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 04:31:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18159.36076.350387.910660@alkaid.it.uu.se>
Date: Tue, 18 Sep 2007 10:31:40 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Francis Moreau" <francis.moro@gmail.com>
Cc: "Ulrich Drepper" <drepper@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: x86_64: vsyscall vs vdso
In-Reply-To: <38b2ab8a0709171322v75c5a597of9d90919f456767c@mail.gmail.com>
References: <38b2ab8a0709161324p6841c1f9h6f9422b0e6c4b5cd@mail.gmail.com>
	<a36005b50709161346t544d3927mfbca537c869c3c58@mail.gmail.com>
	<38b2ab8a0709170030k2b5dad5dja31edebf12ad9626@mail.gmail.com>
	<a36005b50709170735p7c98608ftf12398f7080131b9@mail.gmail.com>
	<38b2ab8a0709171322v75c5a597of9d90919f456767c@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau writes:
 > On 9/17/07, Ulrich Drepper <drepper@gmail.com> wrote:
 > > On 9/17/07, Francis Moreau <francis.moro@gmail.com> wrote:
 > > > I think signal trampolines will still need them too. So making
 > > > vsyscalls configurable doesn't seem to work, does it ?
 > >
 > > vsyscalls aren't used for that.  We have a restorer in libc and could
 > > easily use one in the vdso.  That's what is done on x86.
 > >
 > 
 > Sorry for my ignorance but what' is 'a restorer' ?

When the kernel sets up the context for a user-space signal
handler, it needs to supply a return address (in a register
or on the stack). That's the restorer. The restorer points
to a stub that performs sys_{rt_,}sigreturn(). Depending on
architecture and kernel version, the restorer stub can be
defined by libc, or be provided automatically by the kernel.
