Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab0CBH2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 02:28:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499Ab0CBH2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 02:28:30 -0500
Date: Tue, 2 Mar 2010 09:28:09 +0200
From: Gleb Natapov <gleb@redhat.com>
To: john cooper <john.cooper@third-harmonic.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, avi@redhat.com,
       mtosatti@redhat.com, zamsden@redhat.com
Subject: Re: use of setjmp/longjmp in x86 emulator.
Message-ID: <20100302072809.GS16909@redhat.com>
References: <20100301091819.GD16909@redhat.com>
 <4B8BB6FA.1000505@oss.ntt.co.jp>
 <20100301125223.GI16909@redhat.com>
 <4B8BBE61.3020503@oss.ntt.co.jp>
 <20100301132609.GJ16909@redhat.com>
 <4B8C11DC.1060004@third-harmonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8C11DC.1060004@third-harmonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 02:13:32PM -0500, john cooper wrote:
> Gleb Natapov wrote:
> 
> >Think about what happens if in the middle of
> >instruction emulation some data from device emulated in userspace is
> >needed. Emulator should be able to tell KVM that exit to userspace is
> >needed and restart instruction emulation when data is available.
> 
> setjmp/longjmp are useful constructs in general but
> IME are better suited for infrequent exceptions vs.
> routine usage.
Exception condition during instruction emulation _is_
infrequent. Although setjmp/longjmp that I know about
are routine usage. See QEMU TCG main loop or userspace
thread libraries.

> If the issue is finding some clean and regular way
> to back out from (and possibly reeneter) logic
> expressed within nested function invocations, have
> you considered turning the problem inside out and
> using a state machine approach?
I don't see how state machine will help. But the goal
is not to rewrite emulator.c (this will no be excepted
by kvm maintainers), but improve it gradually.

--
			Gleb.
