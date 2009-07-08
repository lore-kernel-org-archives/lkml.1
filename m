Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbZGHHSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbZGHHSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 03:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZGHHSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 03:18:43 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34849 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZGHHSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 03:18:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R0Ss8gH44wotxbrfLLMpuQbvthE+Cfl0+0j498c1/2gfSRjPxhDR62Dp6DpcV7Nq9y
         HiD73wcoqFxQGwo8Jvyci7EzovCnkZa0t7Ft8eK/xGhCi45hBKaoXzxf87kgKaq52eVB
         Qt5yb9wcQG9SxOdlrw/hY/2i/o1hcuIOb9o+8=
Date: Wed, 8 Jul 2009 09:18:31 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Oleg Nesterov <oleg@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, fbl@redhat.com, nhorman@redhat.com,
       davem@redhat.com, htejun@gmail.com, davidel@xmailserver.org
Subject: Re: [PATCHv5 2/2] memory barrier: adding smp_mb__after_lock
Message-ID: <20090708071831.GB3148@ami.dom.local>
References: <20090707140135.GA5506@Krystal> <20090707143416.GB11704@redhat.com> <20090707150406.GC7124@Krystal> <20090707154440.GA15605@redhat.com> <1246981815.9777.12.camel@twins> <20090707194533.GB13858@Krystal> <4A53CFDC.6080005@gmail.com> <20090707232811.GC19217@Krystal> <20090707235149.GA10268@redhat.com> <20090708043432.GB26180@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708043432.GB26180@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 12:34:32AM -0400, Mathieu Desnoyers wrote:
...
> Because adding smp_mb__after_lock() is _only_ useful on x86. Most other
> architectures _will_ suffer from a performance degradation, unless you
> implement the __read_lock_noacquire.

It's completely backwards: processor barriers are just expected to
add a performance degradation. That's like:

x86 developer:
OK, we need to add a barrier here: even x86 might need this.

Alpha developer:
Right, than we need this even more.

x86 developer:
But wait, we can avoid it using a dummy after some locks, because they
have such a barrier already.

Alpha developer:
Then it's not OK: it's _only_ useful on x86; our architecture _will_
suffer from a performance degradation...

Cheers,
Jarek P.
