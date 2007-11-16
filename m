Return-Path: <linux-kernel-owner+w=401wt.eu-S935473AbXKPX0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935473AbXKPX0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935028AbXKPXMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:12:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56898 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933094AbXKPXMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:12:14 -0500
Date: Fri, 16 Nov 2007 15:10:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       torvalds@linux-foundation.org, sam@ravnborg.org,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [patch 2/4] Add HAVE_OPROFILE
Message-Id: <20071116151031.4b18e9e1.akpm@linux-foundation.org>
In-Reply-To: <20071116033207.794556263@polymtl.ca>
References: <20071116033057.304933306@polymtl.ca>
	<20071116033207.794556263@polymtl.ca>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 22:30:59 -0500
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Linus:
> On the per-architecture side, I do think it would be better to *not* have
> internal architecture knowledge in a generic file, and as such a line like
> 
>         depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32
> 
> really shouldn't exist in a file like kernel/Kconfig.instrumentation.
> 
> It would be much better to do
> 
>         depends on ARCH_SUPPORTS_KPROBES
> 
> in that generic file, and then architectures that do support it would just
> have a
> 
>         bool ARCH_SUPPORTS_KPROBES
>                 default y
> 
> in *their* architecture files. That would seem to be much more logical,
> and is readable both for arch maintainers *and* for people who have no
> clue - and don't care - about which architecture is supposed to support
> which interface...

argh, I merged the previous version.  Dropped it again.

> Changelog:
> 
> Actually, I know I gave this as the magic incantation, but now that I see
> it, I realize that I should have told you to just use
> 
>         config ARCH_SUPPORTS_KPROBES
>                 def_bool y
> 
> instead, which is a bit denser.
> 
> We seem to use both kinds of syntax for these things, but this is really
> what "def_bool" is there for...
> 
> - Use ARCH_HAS_* instead of ARCH_SUPPORTS).
> - Use a select ARCH_HAS_*
> 
> - Yet another update :
> 
> Moving to HAVE_* now.

Please don't do changelogs this way (ie: provide a wrong changelog plus
erratum).

Just update the changelog so that it is in its final form, thanks.

It's fine to add a note at the bottm describing what changed since the
previous patchset - I'll just trim that away for the final git commit.

