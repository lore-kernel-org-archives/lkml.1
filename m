Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbYJaSYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbYJaSYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 14:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYJaSYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 14:24:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35027 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYJaSYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 14:24:14 -0400
Date: Fri, 31 Oct 2008 18:24:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: alpha: undefined reference to `save_stack_trace'
Message-ID: <20081031182411.GR28946@ZenIV.linux.org.uk>
References: <20081031165751.GA13558@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031165751.GA13558@x200.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 07:57:51PM +0300, Alexey Dobriyan wrote:
> On alpha-smp-[ny]-debug-y:
> 
>   LD      .tmp_vmlinux1
> kernel/built-in.o: In function `ftrace_trace_stack':
> (.text+0x706fc): undefined reference to `save_stack_trace'
> 
> 
> Somehow STACKTRACE is set despite no STACKTRACE_SUPPORT.

select blows, film at 11.  TRACING blindly selects STACKTRACE, with a bunch
of stuff in kernel/tracing/Kconfig doing select of TRACING.  Not just an alpha
problem, BTW.

FWIW, we probably ought to make scripts/kconfig/conf check if dependencies
are satisfied before writing .config out and scream bloody murder if they
are not.
