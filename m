Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbXAaBTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbXAaBTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932098AbXAaBTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:19:09 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:31573 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932106AbXAaBTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:19:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=E6B8llXvcn+b8rct32UwO4peb37IpxnUAX4LLLTNRpR5BJpVcUJi9Iom/6KF+1xNYY9vgLuFJFbWyDsdc4m+Hv+8vds1k9HQ3gSv02MpgwIjTkuKDTPYr426RPQB/r/2ToSoMcZOORjdRAPiXYVgAaNjpHVYCYeMINoj0w+G7Tk=  ;
X-YMail-OSG: lBzyxhsVM1mh9xe2vIvEtN6RFAOokuKlp1Kyiu.ohC4bFgUaRYkcDQgC5_SONCtrol80O1bYBw--
Message-ID: <45BFEE7D.7060509@yahoo.com.au>
Date: Wed, 31 Jan 2007 12:18:53 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Anton Altaparmakov <aia21@cam.ac.uk>
CC: Mark Fasheh <mark.fasheh@oracle.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       David Howells <dhowells@redhat.com>, Andrew Morton <akpm@osdl.org>
Subject: Re: page_mkwrite caller is racy?
References: <45BDCA8A.4050809@yahoo.com.au> <Pine.LNX.4.64.0701291521540.24726@blonde.wat.veritas.com> <45BE9BF0.10202@yahoo.com.au> <20070130015159.GA14799@ca-server1.us.oracle.com> <Pine.LNX.4.64.0701301456250.6541@hermes-1.csi.cam.ac.uk>
In-Reply-To: <Pine.LNX.4.64.0701301456250.6541@hermes-1.csi.cam.ac.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Altaparmakov wrote:
> On Mon, 29 Jan 2007, Mark Fasheh wrote:
> 
>>
>>No page lock please. Generally, Ocfs2 wants to order cluster locks outside
>>of page locks. Also, the sparse b-tree support I'm working on right now will
>>need to be able to allocate in ->page_mkwrite() which would become very
>>nasty if we came in with the page lock - aside from the additional cluster
>>locks taken, ocfs2 will want to zero some adjacent pages (because we support
>>atomic allocation up to 1 meg).
> 
> 
> Ditto for NTFS.  I will need to lock pages on both sides of the page for 
> large volume cluster sizes thus I will have to drop the page lock if it is 
> already taken so it might as well not be...  Although I do not feel 
> strongly about it.  If the page is locked I will just drop the lock and 
> then take it again.  If possible to not have the page locked that would 
> make my code a little easier/more efficient I expect...

OK, that makes sense. Thanks to you both.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
