Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbXJaFLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbXJaFLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 01:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbXJaFLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 01:11:08 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:21973 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753427AbXJaFLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 01:11:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oOmxqoQwpiDQJoouUVRVa9PveYB3mEO10xeI5sFj2IiykPiz807uC39Sbxn3pGD6JPPmjKJxKSU0Yg/a9yDh6+6zwZVWmId3/DzPJtqqZjRyohKOyQAmXlQMQ3ej1/nX753OfPq3oAe2acd9zc0v71ZlVGYMvbzqf/yoZHMuPY4=  ;
X-YMail-OSG: 6mJV7kYVM1n69213OtVKVp6SmxQpdyUOIJOWQC8m23r6v1tl30bFPuAGSLdQRYUJuavYMdDEGw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/33] Swap over NFS -v14
Date: Wed, 31 Oct 2007 15:04:23 +1100
User-Agent: KMail/1.9.5
Cc: a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
References: <20071030160401.296770000@chello.nl> <200710311426.33223.nickpiggin@yahoo.com.au> <20071030.213753.126064697.davem@davemloft.net>
In-Reply-To: <20071030.213753.126064697.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710311504.24016.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2007 15:37, David Miller wrote:
> From: Nick Piggin <nickpiggin@yahoo.com.au>
> Date: Wed, 31 Oct 2007 14:26:32 +1100
>
> > Is it really worth all the added complexity of making swap
> > over NFS files work, given that you could use a network block
> > device instead?
>
> Don't be misled.  Swapping over NFS is just a scarecrow for the
> seemingly real impetus behind these changes which is network storage
> stuff like iSCSI.

Oh, I'm OK with the network reserves stuff (not the actual patch,
which I'm not really qualified to review, but at least the idea
of it...).

And also I'm not as such against the idea of swap over network.

However, specifically the change to make swapfiles work through
the filesystem layer (ATM it goes straight to the block layer,
modulo some initialisation stuff which uses block filesystem-
specific calls).

I mean, I assume that anybody trying to swap over network *today*
has to be using a network block device anyway, so the idea of
just being able to transparently improve that case seems better
than adding new complexities for seemingly not much gain.
