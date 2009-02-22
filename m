Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZBVUay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZBVUay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 15:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbZBVUao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 15:30:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:48636 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbZBVUan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 15:30:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KE+JlWkXggwNW2q739l33PzrdoZ94PqrIT9zg2Sm0gqbhQmyHnXQ4R9n4b35zsy50r
         So95Y5R83HOYEhyZQhsfoOoZVjEnp2jrOhd5BH/cEKEn7QMYBuq/U7WqD758pF2KkJ2A
         +dPH4S63URIedPVYHPdowPoZGJAJ6GG06T6hc=
Date: Sun, 22 Feb 2009 21:30:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Bob Copeland <me@bobcopeland.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090222203038.GB6060@nowhere>
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <20090222171032.GD6003@nowhere> <49A1A72A.50102@gmail.com> <20090222194236.GA6060@nowhere> <20090222201821.GA21375@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222201821.GA21375@silver.sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 08:18:22PM +0000, Sitsofe Wheeler wrote:
> On Sun, Feb 22, 2009 at 08:42:37PM +0100, Frederic Weisbecker wrote:
> > On Sun, Feb 22, 2009 at 08:27:38PM +0100, Jiri Slaby wrote:
> > > On 22.2.2009 18:10, Frederic Weisbecker wrote:
> > >> I have some troubles with kmemcheck, so I give up for now.
> > >> Well, by reading the kmemcheck documentation, it tells that there can be some false
> > >> positives so...
> > >
> > > This has nothing to do with kmemcheck.
> > >
> > >> Since we are not sure this is a real bug, I'm not sure it would be interesting.
> > >
> > > There is no false positive possibility with these checkers, so this is  
> > > pretty much interesting, because it is a bug.
> > 
> > 
> > If so, Documentation/kmemcheck.txt really needs an update.
> 
> kmemcheck is different to the slab object lifetime debugger (which is
> what reported this error). kmemcheck may have turned up in the trace
> because it was compiled in (and it ties into slab/slub) but wasn't
> turned on (it can be dynamically toggled via sysfs).


Ah sorry, I thought it was a kmemcheck warning. That's why I didn't understand
what Jiri said to me.

 
> kmemcheck keeps a shadow of the memory and via the shadow memory it
> records whether the memory has been written to yet. I believe
> kmemcheck's problem is that it can't know when allocated but
> uninitialised memory is being used on purpose/not really being used
> (e.g. when gcc does a 32 bit read when only 16 bits have been used but
> throws the upper 16 bits away). There may be other cases such as when a
> previously uninitialised buffer is used but the buffer is actually used
> by an mmaped device...


Ok.

> My understanding is that the slab debugger writes poison about the place
> (e.g. to memory that has been freed and at the start/end of allocations)
> and then checks to see if someone has scribbled on it. This case is more
> coarse as it only deals with allocation rather than initialisation (and
> if you scribble the same value as the poison pattern you go undetected)
> but I believe this is what Jiri is referring to as a "no false positive
> possibility" case - it's never right to write to unallocated memory.
> 
> (fixed up Bob's email address on the cc)


Well I understand better now. Thanks for the explanations.
 
> -- 
> Sitsofe | http://sucs.org/~sits/

