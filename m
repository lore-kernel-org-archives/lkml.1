Return-Path: <linux-kernel-owner+w=401wt.eu-S933491AbYBHHNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491AbYBHHNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 02:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbYBHHM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 02:12:58 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:43615 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757005AbYBHHM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 02:12:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Hfqm0NfbVg7Zs6GGEUEHzdc7/vIFHcvFu6mropv4Rt8a2Kvs+Sf8cp65JjeVqSNyd16Hy5QdoIF8rk/Vlko14qsgVtPZmbS/F3wq0b79HuIJ4nrP5g0r4vOr2OkqpeScyr1/d73Z6pMljOe3jmQ34jO/nqVgkcRmg9cnynWYvQo=  ;
X-YMail-OSG: 2PZu24kVM1kn_3ov7DqcLJZvucYUbSqGdBssBNoQxxZYBBpsYOv7Kn8pR3qr7GEGdq63bM1inIrFpwR6ynAqQtcgKdk3tbi1tjAsHjN.3UlvpVYrejAKfTAlIykCAg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [git pull] more SLUB updates for 2.6.25
Date: Fri, 8 Feb 2008 18:12:21 +1100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
References: <Pine.LNX.4.64.0802071755580.7473@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0802071755580.7473@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802081812.22513.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 February 2008 13:13, Christoph Lameter wrote:
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/christoph/vm.git slub-linus
>
> (includes the cmpxchg_local fastpath since the cmpxchg_local work
> by Matheiu is in now, and the non atomic unlock by Nick. Verified that
> this is not doing any harm after some other patches had been removed.

Ah, good. I think it is always a good thing to be able to remove atomics.
They place quite a bit of burden on the CPU, especially x86 where it also
has implicit memory ordering semantics (although x86 can speculatively
get around much of the problem, it's obviously worse than no restriction)

Even if perhaps some cache coherency or timing quirk makes the non-atomic
version slower (all else being equal), then I'd still say that the non
atomic version should be preferred.

Thanks,
Nick

