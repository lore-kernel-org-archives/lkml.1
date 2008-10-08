Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYJHItZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYJHItZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 04:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYJHItM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 04:49:12 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:36872 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754050AbYJHItK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 04:49:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=y8x5u4Lq3ZHVNNXRHHqXsC2fDfKWb/AkTmSNiBBgGj8lEfNAWX+jcL1+Mrt72k7J5ehpdWE/MhIePHL2DDLkTHMSwq9SsVbig007QPGVwK4m/EjugKHK2lnk0DWhiTdKEXJD7NJRiw0UWjd3Nq/EYYTrRT0jkF4t3q8ERbGo5xo=  ;
X-YMail-OSG: 94qbeccVM1kX4quFYX63H0HAOg5JgJPtt0S8NrwqC6rsWBoI8r.vmjvr9i6lA41mGnwCDSsawVBVQFHKwn7Zj9ytXilW.enr_uZ60IP2.Nvw1xPcIe36.rcRNRla9ZXOBikyFpNviGcxUvn2xNqYK4vzC38KqQir8rNkww8cFw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit arch
Date: Wed, 8 Oct 2008 19:48:59 +1100
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2> <1223448711.1378.16.camel@lappy.programming.kicks-ass.net> <48EC7003.4040108@cosmosbay.com>
In-Reply-To: <48EC7003.4040108@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810081949.00556.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008 19:32, Eric Dumazet wrote:

> A far more interesting problem is the "tail -f logfile" problem that raised
> recently in lkml, when file is NFS mounted, where reader can get nul
> bytes... (Subject : blocks of zeros (NULLs) in NFS files in kernels >=
> 2.6.20 )

Not so interesting outside NFS, AFAIKS? It's just a matter of what
semantics NFS chooses to implement... I guess stronger semantics
will tend to be more costly, all else being equal, probably the
reason why they do it that way.

That behaviour does seem a bit surprising, though.
