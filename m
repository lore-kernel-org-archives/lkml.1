Return-Path: <linux-kernel-owner+w=401wt.eu-S1762881AbYCFMx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762881AbYCFMx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760618AbYCFMxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:53:38 -0500
Received: from n20.bullet.mail.mud.yahoo.com ([68.142.200.47]:33850 "HELO
	n20.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933813AbYCFMxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:53:37 -0500
X-Yahoo-Newman-Id: 930444.36186.bm@omp418.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=188Bw8TaEsQwngYWaKWK66Sr9ZL5wQrVnaKD0mUTEzF6nnugN1OuJtZgazox/azVamX9VLEJh+iTwd1oW92G8p+s5XmPyCu5gU6XMSMVWYFfwnI2GRo9ZSrJCFpJQ5edjsK/9bykqdAJ9MuzMVylF1X3T9n+DSNUKjdtb5nu060=  ;
X-YMail-OSG: z5y6bbEVM1n7Jfor_l_XCo0KQmgR.B6SzIAx3xfHs0bf_vsM_xWbFGvDAo1SVnXoRfYrv.7QjvMReNtnnxAzZQ1v_aBXYFFA84a69z8IJZwW5qZW8mvHnPkej5mHNA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Performance versus FreeBSD 7.0
Date: Thu, 6 Mar 2008 23:53:06 +1100
User-Agent: KMail/1.9.5
Cc: Cyrus Massoumi <cyrusm@gmx.net>, Diego Calleja <diegocg@gmail.com>,
       Stephen Cuppett <cuppett@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, a.p.zijlstra@chello.nl
References: <316a20a40802290538g55c4171y7cdbcb3a9c1d0f1b@mail.gmail.com> <47CC4B3F.8060405@gmx.net> <p73y78z5r3k.fsf@bingen.suse.de>
In-Reply-To: <p73y78z5r3k.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803062353.07298.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008 10:23, Andi Kleen wrote:

> You're totally on the wrong path here I think.

In my testing, I found that Linux is a bit faster and more scalable
than FreeBSD on MySQL sysbench.

http://www.kernel.org/pub/linux/kernel/people/npiggin/sysbench/

I think since the mmap_sem madvise problem was solved, the kernel
didn't really have any further problems with this workload.

It is doing a lot of context switches, no IO, and not a lot of
real work. The DBMS runs into some scalability problems in this
workload, but to be fair it is probably not one that the MySQL
guys care about too much. But it sometimes seems a bit sloppy...
eg. a full 35% of the syscalls the MySQL server makes are failed
sched_setparam calls that are passing in invalid values.

So I don't really consider it a big victory to be slightly faster
here; nobody really noticed until this test that we had the silly
performance bug in our malloc/free paths in glibc and the kernel.

