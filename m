Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbZELSIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbZELSIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 14:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZELSIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 14:08:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37688 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbZELSIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 14:08:21 -0400
Date: Tue, 12 May 2009 20:13:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Tobias Doerffel <tobias.doerffel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Specific support for Intel Atom architecture
Message-ID: <20090512181338.GK19296@one.firstfloor.org>
References: <200904301408.09370.tobias.doerffel@gmail.com> <877i0xib7d.fsf@basil.nowhere.org> <a36005b50905120720p14e0ea0av79f99551262a920a@mail.gmail.com> <20090512150408.GH19296@one.firstfloor.org> <a36005b50905121045s62c16760p3aba003647a572c7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36005b50905121045s62c16760p3aba003647a572c7@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 10:45:00AM -0700, Ulrich Drepper wrote:
> On Tue, May 12, 2009 at 8:04 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > The problem is that you can't express the situations where
> > movbe is better than bswap (you need both and the old and the new
> > value) in inline assembler in a way that gcc decides automatically.
> 
> True.  But I was mostly thinking about loads from memory.  A quick
> search for ntoh*/hton* shows code like
> 
>         u_int16_t queue_num = ntohs(nfmsg->res_id);
> 
> If there would be a ntohs_load() macro movbe could be used.

It wouldn't surprise me if

	movbe memory,%reg

generates the same uops sequence internally as

	mov memory,%reg
	bswap %reg

I doubt there's any dedicated hardware for this in Atom (but I don't
know for sure) 

So unless you're really decoding constrained it would only
save a few bytes of code size. Probably not worth having 
incompatible modules for or adding special code to the source.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
