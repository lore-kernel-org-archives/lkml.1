Return-Path: <linux-kernel-owner+w=401wt.eu-S937224AbXGTCDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937224AbXGTCDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 22:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761608AbXGTCDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 22:03:24 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:45911 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763195AbXGTCDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 22:03:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Rn1BAWiyFIUfd0H8cFNrKEBNLF0kZwkQLmdZ1FFob/3wfo19aunHjNQJk7zv0u/JAzC+7YeAfuRie5or2GSe3qqyH779vUOVvYVjQUtowoodoaymlUrf9JFNPmwkDVun0bHqk5oIwdXvAfyDq5U1KGSGScSt58DxSscnA94k0uc=  ;
X-YMail-OSG: tQeuqKsVM1kL9kOrjIrIH04DPDyWlxW4Tk1XZ.qOKVFD1SiirQPEcgold0bmokMWvlfz_HnIOg--
Message-ID: <469DABA5.9070706@yahoo.com.au>
Date: Wed, 18 Jul 2007 15:56:53 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AFS: Fix file locking
References: <20070717124732.22619.34179.stgit@warthog.cambridge.redhat.com> <20070717175017.8b8a8976.akpm@linux-foundation.org>
In-Reply-To: <20070717175017.8b8a8976.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 17 Jul 2007 13:47:32 +0100
> David Howells <dhowells@redhat.com> wrote:
> 
> 
>>+	if (type == AFS_LOCK_READ &&
>>+	    vnode->flags & (1 << AFS_VNODE_READLOCKED)) {
> 
> 
> Here we use
> 
> 	vnode->flags & (1 << foo)
> 
> 
>>+		set_bit(AFS_VNODE_LOCKING, &vnode->flags);
> 
> 
> and elsewhere we use set_bit(foo, &vnode->flags) and clear_bit()
> 
> This is a bit strange.  Does the open-coded bit-test have any performance
> benefit on any architecture?  Not on x86 at least, afaik.

It uses locked operations on x86, but you can use __set_bit instead
(which should always be at least as efficient as the C version).

-- 
SUSE Labs, Novell Inc.
