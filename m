Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbXERCaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbXERCaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 22:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbXERC3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 22:29:55 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:27391 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755753AbXERC3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 22:29:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=pMoR8usez77KzTChqDlQgrF4Gm1s4QUSbXQnoJ/PIKs2zEtkkuJDWKnO6NZKV0LKhU1G9ju+auP3QAwa1NGtifLvFTaBhJWIt/tQk2BGWo+dy0Bat1ilUQZfC9CE+4p2jaNRUNO+gS7nRgBxNyH/4x+3SVSpFJoPDBecQr6FhxE=  ;
X-YMail-OSG: Zj3dT6sVM1nButH9abXcALRUUKR4HILVJmzzeP9SnuMgH7whkiCGPqGTPknYhXijgnK3c_OJNw--
Message-ID: <464D0F9D.9070303@yahoo.com.au>
Date: Fri, 18 May 2007 12:29:49 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement shared-writable mmap [try #2]
References: <464BF8B2.3080101@yahoo.com.au> <464B3F2D.9030603@yahoo.com.au> <464B3209.4010003@yahoo.com.au> <464B07EC.4050308@yahoo.com.au> <464AF3F3.30204@yahoo.com.au> <20070516100225.18685.51699.stgit@warthog.cambridge.redhat.com> <17173.1179321391@redhat.com> <19714.1179331928@redhat.com> <23262.1179334587@redhat.com> <31162.1179341123@redhat.com> <6333.1179405001@redhat.com>
In-Reply-To: <6333.1179405001@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>No, you shouldn't. We could theoretically introduce a new API for this,
>>but I think it would be preferable if you can fix the race in the fs.
> 
> 
> Actually, I might be able to do better.
> 
> When making a StoreData call to the AFS server, I send all the parameters
> first, and at that point, the server will abort it, I think, if permission is
> not available, and won't wait for the payload to be delivered.
> 
> So if I tell AF_RXRPC to send the parameter data with an explicit ACK request
> and then wait till it's either hard-ACK'd or aborted, I should then be able to
> deal with the permissions failure at a state where I have locked *all* the
> pages to be sent.
> 
> At that point, I should be able to tell truncate to simple discard all these
> locked pages.
> 
> How's that sound?

Truncate as it stands still needs to be given unlocked pages. So we would
either have to create a new API, or I think preferably it would be nice if
you could see if you can first solve it with a private lock?

-- 
SUSE Labs, Novell Inc.
