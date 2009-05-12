Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbZELO7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbZELO7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 10:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZELO6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 10:58:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35770 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbZELO6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 10:58:52 -0400
Date: Tue, 12 May 2009 17:04:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Tobias Doerffel <tobias.doerffel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Specific support for Intel Atom architecture
Message-ID: <20090512150408.GH19296@one.firstfloor.org>
References: <200904301408.09370.tobias.doerffel@gmail.com> <877i0xib7d.fsf@basil.nowhere.org> <a36005b50905120720p14e0ea0av79f99551262a920a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36005b50905120720p14e0ea0av79f99551262a920a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 07:20:14AM -0700, Ulrich Drepper wrote:
> On Mon, May 4, 2009 at 12:22 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > This should be obsolete anyways, you can just uses CORE2. They have compatible ISAs.
> 
> Only correct if you don't plan to use the movbe instruction.  The
> kernel would be the one place where I can imagine this to make sense.

The problem is that you can't express the situations where
movbe is better than bswap (you need both and the old and the new
value) in inline assembler in a way that gcc decides automatically.

I also doubt there are many (any?) situations in the kernel where
the destruction of the old register is a problem in the kernel;
e.g. the network stack normally doesn't care.

My understanding is that movbe is really mainly useful for 
some special situations where you run a emulator/jit for 
a BE ISA, but that's not something the kernel does.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
