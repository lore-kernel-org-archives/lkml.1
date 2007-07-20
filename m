Return-Path: <linux-kernel-owner+w=401wt.eu-S940176AbXGUB0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940176AbXGUB0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 21:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764711AbXGUB0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 21:26:10 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:21903 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764307AbXGUB0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 21:26:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=pIFS+svqWniTu2SuMM5bvl8MoQk9edPcqCZj4x8jkKK0GN0yaRfthP3UWLTg4UzThSTfBCHXfMHonkFrnvnTYne4/VbnaUerDf1bKd4LvJz0el5ErlxoT0kX/jKVC7OZJ2H0GfzhIOQ69VVCHw63Z3Lgk0kra1dQOgXxc53KJ6M=  ;
X-YMail-OSG: T86QQb8VM1l2m7B4821mS4cQxUa3EBryO_IwHgGW8.1ghiB_q0BzL5QVK8zefctPJMntD.J8Gw--
Message-ID: <46A04129.1020900@yahoo.com.au>
Date: Fri, 20 Jul 2007 14:59:21 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AFS: Fix file locking
References: <20070717124732.22619.34179.stgit@warthog.cambridge.redhat.com>	<20070717175017.8b8a8976.akpm@linux-foundation.org>	<469DABA5.9070706@yahoo.com.au> <20070719204102.7b82692d.akpm@linux-foundation.org>
In-Reply-To: <20070719204102.7b82692d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 18 Jul 2007 15:56:53 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>Andrew Morton wrote:
>>
>>>On Tue, 17 Jul 2007 13:47:32 +0100
>>>David Howells <dhowells@redhat.com> wrote:
>>>
>>>
>>>
>>>>+	if (type == AFS_LOCK_READ &&
>>>>+	    vnode->flags & (1 << AFS_VNODE_READLOCKED)) {
>>>
>>>
>>>Here we use
>>>
>>>	vnode->flags & (1 << foo)
>>>
>>>
>>>
>>>>+		set_bit(AFS_VNODE_LOCKING, &vnode->flags);
>>>
>>>
>>>and elsewhere we use set_bit(foo, &vnode->flags) and clear_bit()
>>>
>>>This is a bit strange.  Does the open-coded bit-test have any performance
>>>benefit on any architecture?  Not on x86 at least, afaik.
>>
>>It uses locked operations on x86, but you can use __set_bit instead
>>(which should always be at least as efficient as the C version).
> 
> 
> I said "bit-test".  ie: test_bit().  That doesn't use a locked operation.

So you did. Then to answer that, yes it could be faster because there are
stupid volatiles sprinkled all over the bitops code so you could easily
end up having to do more loads. Does it make a real difference? Unlikely,
but David loves counting cycles :)

-- 
SUSE Labs, Novell Inc.
