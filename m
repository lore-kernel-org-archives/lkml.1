Return-Path: <linux-kernel-owner+w=401wt.eu-S1759798AbZD0Sry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798AbZD0Sry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758180AbZD0Srn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:47:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39103 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZD0Srn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:47:43 -0400
Date: Mon, 27 Apr 2009 20:43:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: arch/ && tracehook_report_syscall_xxx()
Message-ID: <20090427184355.GA3281@redhat.com>
References: <20090427180455.GA32509@redhat.com> <20090427182919.B923DFC3BF@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427182919.B923DFC3BF@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27, Roland McGrath wrote:
>
> > We have a lot of code like arch/alpha/kernel/ptrace.c:syscall_trace()
> > in arch/ and I can't see how to convert them to use tracehooks.
> >
> > The first problem, we don't know which hook should be called, there is
> > no entry/exit argument.
>
> These arch maintainers just need to update their code.  Christoph has
> started poking arch folks individually about getting up to speed.

Ah, good.

> IMHO, it is better anyway to use separate entry/exit calls.  For that
> change, it is often easy to see how to do it correctly in the assembly code
> without really knowing the arch at all.  (There are separate assembly paths
> leading to the calls for entry vs exit cases already, just change the
> symbol names.  Adding an argument would require a bit of a clue about
> assembly on the arch.)
>
> > Still, I think it is better to change this code right now, and call
> > ptrace_report_syscall() directly.
>
> I disagree.  Let the arch code get with the modern style.
> It is just a minute's hack for the arch maintainer.

Sure, if maintainers can help then we don't need the temporary/incomplete
changes.

Oleg.

