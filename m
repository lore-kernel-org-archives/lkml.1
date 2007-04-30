Return-Path: <linux-kernel-owner+w=401wt.eu-S965512AbXD3KdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965512AbXD3KdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965483AbXD3Kcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:32:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47171 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbXD3Kcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:32:41 -0400
Date: Mon, 30 Apr 2007 11:32:38 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: utrace comments
Message-ID: <20070430103238.GA10414@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Christoph Hellwig <hch@lst.de>, Roland McGrath <roland@redhat.com>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20061127165138.GA2991@lst.de> <20070430040213.BF9901801A4@magilla.sf.frob.com> <20070430090840.GB31397@infradead.org> <20070430091808.GA11345@flint.arm.linux.org.uk> <20070430092200.GA15773@lst.de> <20070430093331.GB11345@flint.arm.linux.org.uk> <20070430094510.GC11345@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430094510.GC11345@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:45:10AM +0100, Russell King wrote:
> For the sake of avoiding too much rehash, here's Roland's reply to my
> initial forrey into utrace:
> 
>   http://marc.info/?l=linux-kernel&m=117309251916053&w=2

In that mail Roland suggests keeping the singlestep code entirely
in the arm ptrace code.  After a brief look at the arm code this
looks easily possible.  From a brief look the arm software singlestep
consist of the following pieces:

 - PTRACE_SINGLESTEP implementation.  Sets the PT_SINGLESTEP flag,
   clears TIF_SYSCALL_TRACE, sets ->exit_code in the traced code
   to the singlestepping signal and wakes the traced process up.

   This can easily be implemented by putting alsmost equivalent code
   into arch_ptrace.
 - clearing PT_SINGLESTEP and cancelling the breakpoint in ptrace_disable.

   Equivalent code can go into tracehook_disable_single_step.

 - Various places in signal.c that check PT_SINGLESTEP to set/clear
   the special singlestep breakpoint.  This can stay, it just needs
   a different place to store the singlestep flag.

Do I miss something?

