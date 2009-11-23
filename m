Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbZKWVTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbZKWVTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 16:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbZKWVTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 16:19:46 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56629 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbZKWVTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 16:19:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cIvo7hyjIX84y3j8+lEt58mDUXp1YyCC9KNxNX+bF1ZTLWsxPhmbIQX16YTi5qC7Jq
         kLeFnaxbhCPLbIE17sVCJ6WcG/YdclcLUTT6JjzscnhdhYjuhNQobQ1MZ7+fD6UM4c6E
         1zhj7tqk7aDl0waw1J5nT9yWu3AATV8qBFAKI=
Date: Mon, 23 Nov 2009 22:19:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 4/4] perf tools: Add support for breakpoint events in
	perf tools
Message-ID: <20091123211945.GC4979@nowhere>
References: <1258987355-8751-1-git-send-email-fweisbec@gmail.com> <1258987355-8751-4-git-send-email-fweisbec@gmail.com> <20091123173601.GA7273@in.ibm.com> <20091123202525.GA4979@nowhere> <20091123210939.GD15547@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123210939.GD15547@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 07:09:39PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Mon, Nov 23, 2009 at 09:25:28PM +0100, Frederic Weisbecker escreveu:
> > On Mon, Nov 23, 2009 at 11:06:01PM +0530, K.Prasad wrote:
> > > With kernel symbols as input it would be possible to derive the bkpt
> > > length based on the symbol-size, say using kallsyms_lookup_size_offset()
> > > (although the corresponding length may not be available on the host
> > > processor such requests can be failed or over-ridden by the user using
> > > a smaller length), but for addresses I think it is vital to know what
> > > breakpoint length is desired by the user.
>  
> > Yeah. I guess we first need a way to manually add this length, may be:
> 
> > 	mem:addr/len:access
>  
> > And as you said, finding it automatically for symbols. But still,
> > passing symbols to perf attr leads to confusion and complexity if we
> > want to profile in userspace.
>  
> > I think we should find this symbol length from userspace. I'm not sure
> > how yet, probably using Dwarf. Arnaldo, do you have an idea about that?
> 
> DWARF has the type for each variable or struct member, getting its size
> is straightforward.


Ok.

 
> Using just /proc/kallsyms all we can do is find the size of a variable
> by looking at its address and the address of the next one.
> 
> - Arnaldo


Hmm, but I worry a bit about alignment which would return us
the wrong size.

May be can we first try to get the address from /proc/kallsyms,
and if we have dwarf, get the size from it, otherwise try some
magic with /proc/kallsysms...

