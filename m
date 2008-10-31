Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbYJaSsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbYJaSsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 14:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbYJaSs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 14:48:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44900 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbYJaSs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 14:48:26 -0400
Date: Fri, 31 Oct 2008 18:48:22 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: alpha: undefined reference to `save_stack_trace'
Message-ID: <20081031184822.GS28946@ZenIV.linux.org.uk>
References: <20081031165751.GA13558@x200.localdomain> <20081031182411.GR28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031182411.GR28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 06:24:11PM +0000, Al Viro wrote:
> On Fri, Oct 31, 2008 at 07:57:51PM +0300, Alexey Dobriyan wrote:
> > On alpha-smp-[ny]-debug-y:
> > 
> >   LD      .tmp_vmlinux1
> > kernel/built-in.o: In function `ftrace_trace_stack':
> > (.text+0x706fc): undefined reference to `save_stack_trace'
> > 
> > 
> > Somehow STACKTRACE is set despite no STACKTRACE_SUPPORT.
> 
> select blows, film at 11.  TRACING blindly selects STACKTRACE, with a bunch
> of stuff in kernel/tracing/Kconfig doing select of TRACING.  Not just an alpha
> problem, BTW.

While we are at it, we have that particular turd on allmodconfigs on (at least)
	alpha
	blackfin
	cris
	frv
	h8300
	ia64
	m32r
	m68k
	m68knommu
	mn10300
	parisc
	sparc (32bit one, that is)
	uml/i386
	uml/amd64
	xtensa

We could slap && HAS_STACKTRACE_SUPPORT on all symbols that end up selecting
TRACING, but that's almost certainly wrong; the thing won't break if we
simply omit stack trace output on configs that do not have them supported.
Why do we have that select STACKTRACE there, anyway?
