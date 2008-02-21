Return-Path: <linux-kernel-owner+w=401wt.eu-S932280AbYBUVdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbYBUVdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbYBUVdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:33:38 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:7563 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbYBUVdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:33:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QzhRQPlocY2RT9jLl2IIOjiScd2anrl6/9b2oBCgO2MrmvTdhCTDw/wKvgPPm6tH9Tf3Z7G3DY3U1DZjuaxct9D6pibk3ynWwKAMH1NKuDiTqpsXf1Xi13EClSKwDGDGSFrkgUXjS97r3UkDzkZRXHqX3n0nF8rc9z5mtCx0BOA=
Message-ID: <9810cff90802211333k3d19ca2exf28c18ae5a2b86a@mail.gmail.com>
Date: Thu, 21 Feb 2008 13:33:34 -0800
From: "Bill Huey (hui)" <bill.huey@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH [RT] 00/14] RFC - adaptive real-time locks
Cc: "Gregory Haskins" <ghaskins@novell.com>, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, kevin@hilman.org, cminyard@mvista.com,
       dsingleton@mvista.com, dwalker@mvista.com, npiggin@suse.de,
       dsaxena@plexity.net, ak@suse.de, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com
In-Reply-To: <20080221212420.GA20953@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
	 <20080221212420.GA20953@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would also help to get the lockdep/lockstat output for those runs
so that more discussion can happen. That framework can be extended to
do all sorts of contention tracking and that is why I took implemented
it in the first place to track the viability of adaptive spins. My
initial results where that about 10 percent (heavier against BKL)
where suitable for adaptive spins and 10 percent roughly for ownership
stealing. The current implementation didn't seem to have those
measurements coded in just yet (unlike my private implementation).

I came to the original conclusion that it wasn't originally worth it,
but the dbench number published say otherwise. It would be a good
thing to get both a precise chunk of instrumentation to show where the
problems are (these number could be skewed by a number of things) as
well as the specific locks that are contended against.

See ya

bill

On Thu, Feb 21, 2008 at 1:24 PM, Ingo Molnar <mingo@elte.hu> wrote:
>  regarding the concept: adaptive mutexes have been talked about in the
>  past, but their advantage is not at all clear, that's why we havent done
>  them. It's definitely not an unambigiously win-win concept.
>
>  So lets get some real marketing-free benchmarking done, and we are not
>  just interested in the workloads where a bit of polling on contended
>  locks helps, but we are also interested in workloads where the polling
>  hurts ... And lets please do the comparisons without the ticket spinlock
>  patch ...
