Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbZDNVWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbZDNVWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZDNVWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:22:42 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:53634 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbZDNVWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:22:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KeCaND2vaCb8Gy8K7KUdHQr0KNU7TxM56HgG9JVRcEg+BuPQcUaLe9o3ZSJoGP0ioF
         qVh3rvlUUu6ZxnZ7RdcqFxmVdN1KDsFvCg/4U5xkraCkLzkmujaMU50R3ZEuG/eWE2Ye
         sZV/+DZJUs6sc/xCwwaFf0+Zy1tCPjcTduFGc=
Date: Tue, 14 Apr 2009 23:22:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/lockdep: turn lock->name into an array
Message-ID: <20090414212236.GC5968@nowhere>
References: <1239662166-13208-1-git-send-email-fweisbec@gmail.com> <20090413224219.GK5977@nowhere> <1239695296.21985.6725.camel@twins> <20090414102754.GH3558@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414102754.GH3558@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 12:27:54PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, 2009-04-14 at 00:42 +0200, Frederic Weisbecker wrote:
> > > > +#define LOCK_NAME_SIZE       25
> > > 
> > > 
> > > 
> > > This constant may look a bit weird.
> > > I just started with the assumption that a full lock name
> > > will rarely exceed this length.
> > > 
> > > If you agree with it, I will expand the conversion of lockdep
> > > TRACE_FORMAT to TRACE_EVENTS with the same assumption.
> > > So that we will be able to use filters with locks events.
> > 
> > I really really hate this.
> > 
> > if you pick a size on the top end so that all lock->name's fit in, 
> > you're wasting heaps of space, if you pick a median length, 
> > everything will get truncated.
> > 
> > If you're going to do a copy, just do the print into the buffer by 
> > using _FORMAT and be done with it.
> 
> what i suggested was a variable length field. That solves the size 
> issue. The ring-buffer supports variable size records anyway.
> 
> 	Ingo



Indeed. That's how I plan to change it.
It can become the main new __string() field concept
that we talked about.

