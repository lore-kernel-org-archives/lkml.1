Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbZJSTkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbZJSTkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 15:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbZJSTkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 15:40:25 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:63010 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323AbZJSTkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 15:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fpqE98d6/MR1ZXkls2fTroCGP1oM70r2OkLlaJ3hsJuaymQTo18Hno18bug/QMuCLg
         yNfVjISHYP3SiCd+NdFAb93p0Vs5+J+Tm/g4QzdXSZVVud6yw85GhnZ8EDyytqfEfqGZ
         G43xN5D1twRk28Z4+iJqJeP5xrFYGxjmCoWd8=
Date: Mon, 19 Oct 2009 21:40:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/2] perf tools: Use DECLARE_BITMAP instead of an
	open-coded array
Message-ID: <20091019194020.GC4880@nowhere>
References: <20091016074222.GD30019@elte.hu> <1255795038-13751-1-git-send-email-fweisbec@gmail.com> <20091017160338.GA10344@nowhere> <20091019073039.GC17960@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019073039.GC17960@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 09:30:39AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Sat, Oct 17, 2009 at 05:57:18PM +0200, Frederic Weisbecker wrote:
> > > Use DECLARE_BITMAP instead of an open coded array for our bitmap
> > > of featured sections.
> > > 
> > > This makes the array an unsigned long instead of a u64 but since we 
> > > use a 256 bits bitmap, the array size shouldn't vary between 
> > > different boxes.
> > 
> > That said I would really feel more comfortable if someone can confirm 
> > that.
> 
> Should be size-invariant for the bitmap size of 256 bits due to:
> 
> #define DECLARE_BITMAP(name,bits) \
>         unsigned long name[BITS_TO_LONGS(bits)]
> 
> but it's not little-endian/big-endian invariant.
> 
> We should at minimum save the CPU architecture (and endianness 
> parameters) the data got generated on, and reject 
> endianness-incompatible uses - so that if someone wants to add 
> cross-endian support it can be implemented cleanly.
> 
> 	Ingo


Oh right, I'll add an endianness field then.

Thanks.

