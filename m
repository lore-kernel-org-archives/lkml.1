Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbZD0SdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbZD0SdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbZD0Scw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:32:52 -0400
Received: from verein.lst.de ([213.95.11.210]:32903 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbZD0Scv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:32:51 -0400
Date: Mon, 27 Apr 2009 20:32:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: arch/ && tracehook_report_syscall_xxx()
Message-ID: <20090427183218.GA31596@lst.de>
References: <20090427180455.GA32509@redhat.com> <20090427182919.B923DFC3BF@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427182919.B923DFC3BF@magilla.sf.frob.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 11:29:19AM -0700, Roland McGrath wrote:
> > We have a lot of code like arch/alpha/kernel/ptrace.c:syscall_trace()
> > in arch/ and I can't see how to convert them to use tracehooks.
> > 
> > The first problem, we don't know which hook should be called, there is
> > no entry/exit argument.
> 
> These arch maintainers just need to update their code.  Christoph has
> started poking arch folks individually about getting up to speed.
> 
> IMHO, it is better anyway to use separate entry/exit calls.  For that
> change, it is often easy to see how to do it correctly in the assembly code
> without really knowing the arch at all.  (There are separate assembly paths
> leading to the calls for entry vs exit cases already, just change the
> symbol names.  Adding an argument would require a bit of a clue about
> assembly on the arch.)

I've poked a few arch maintainers in the past to separate the enter/exit
path and usually got the desired changes :)

> > Still, I think it is better to change this code right now, and call
> > ptrace_report_syscall() directly.
> 
> I disagree.  Let the arch code get with the modern style.  
> It is just a minute's hack for the arch maintainer.

Yeah, let's get the architectures up to modern standards first, that
should make life a lot simpler.

