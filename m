Return-Path: <linux-kernel-owner+w=401wt.eu-S964962AbZLPTlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964962AbZLPTlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935487AbZLPTla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:41:30 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49796 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831AbZLPTl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:41:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lcDcWGF1Qm/Hz/CeykrOaEGNmz/alR5ii5V/3YssqQkBSPP654NdPGBTv9G1gHqKl0
         9krZbX/Kaedi8S8k7mCtH6WLMNO5wlUVob57apyZUR5uCaAdu+SPfKhUZq2tcDAnKDV2
         R4hKcQ1RPhvKDXOdB7LdTNwQDc91HdeR64xhc=
Date: Wed, 16 Dec 2009 20:41:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH][RFC] perf lock: Distribute numerical IDs for each lock
	instances
Message-ID: <20091216194117.GD5211@nowhere>
References: <1260691344-4724-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20091214133014.GL5168@nowhere> <a6b9f31a0912140644t50c8aa9y7b6c51339374bb94@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6b9f31a0912140644t50c8aa9y7b6c51339374bb94@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 11:44:53PM +0900, Hitoshi Mitake wrote:
> On Mon, Dec 14, 2009 at 22:30, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > So if I understand well, this maps each lockdep_map
> > into a unique index, right?
> 
> There's a slightly difference. This patch maps each lock instances
> (spinlock_t, rwlock_t, etc) into a unique index.



Yeah.


 
> The usecase I assumed is (for example) that
> dividing copying name of lock instances to userspace from lock trace events.
> 
> I think that copying name of lock at every trace event time is not efficient.
> For example, ID <-> name table can be made in my way.
> So each lock events only have to output it's ID.
> Then, perf lock reads the table from file on debugfs.
> Finally perf lock can refer the table and obtain name of each lock.
> This may reduce the data transfer between kernel and userspace.
> 
> But... you are right. This effect can be also obtained by hashlist.
> There's no requirement of implementing array.
> And optimization should be done after implementation.
> I'll back to coding of perf lock, sorry..
> 
> # But I think that this is useful to measure the overhead of hashlist! :)
> 


Ah I understand better. Indeed if we have such index:lock_name mapping
available from debugfs, the tracing path would be more efficient because
we'd only need to trace the index, no need to copy the name.

Actually that looks like a good idea.

