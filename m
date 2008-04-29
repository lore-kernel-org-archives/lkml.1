Return-Path: <linux-kernel-owner+w=401wt.eu-S1765543AbYD2PDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765543AbYD2PDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756271AbYD2PDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:03:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:12102 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800AbYD2PDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:03:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qgbBHaH05EODKSICTihw6h6KlHSUJ0/GiIpbNXGRtaWfEgeuzwCpS8pZub4vwnOnInR7CjqSafLLXWgSHqKiv/cbHjG7U+1fJaupBDrikyb+iBGEnsriQVAydJzRCW8GT1mCwzaLTcx5d5Dz6KyiEtd+/mCw9zC5CpWok33xWyY=
Message-ID: <e2e108260804290803u75764b56t1c475a6d186aca8d@mail.gmail.com>
Date: Tue, 29 Apr 2008 17:03:38 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/8] lockdep: fix recursive read lock validation
Cc: ego@in.ibm.com, linux-kernel@vger.kernel.org,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
       "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Srivatsa Vaddagiri" <vatsa@in.ibm.com>
In-Reply-To: <1209481050.13978.72.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429125659.GA23562@in.ibm.com>
	 <20080429125750.GB23562@in.ibm.com>
	 <e2e108260804290616l489ac8c2udcb2e80fc268b72b@mail.gmail.com>
	 <1209481050.13978.72.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 4:57 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Tue, 2008-04-29 at 15:16 +0200, Bart Van Assche wrote:
>  > On Tue, Apr 29, 2008 at 2:57 PM, Gautham R Shenoy <ego@in.ibm.com> wrote:
>  > > Subject: lockdep: fix recursive read lock validation
>  > >  This means that the following sequence is now invalid, whereas previously
>  > >  it was considered valid:
>  > >
>  > >   rlock(a); rlock(b); runlock(b); runlock(a)
>  > >   rlock(b); rlock(a);
>  >
>  > Why are you marking this sequence as invalid ? Although it can be
>  > debated whether it is good programming practice to be inconsistent
>  > about the order of read-locking, the above sequence can't be involved
>  > in a deadlock.
>
>  Not for pure read locks, but when you add write locks to it, it does get
>  deadlocky. Lockdep does not keep separate chains for read and write
>  locks.

Nesting writer locks inside reader locks is always a bad idea. So
please come up with an example of how varying the reader lock nesting
order can trigger a deadlock (when no writer locks are nested inside
reader locks and nested writer locks are always nested in the same
order).

Bart.
