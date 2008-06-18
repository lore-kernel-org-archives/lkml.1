Return-Path: <linux-kernel-owner+w=401wt.eu-S1760645AbYFRGKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645AbYFRGKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 02:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758356AbYFRGKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 02:10:32 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:35497 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758629AbYFRGKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 02:10:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=SoyF3EP2nHMMcj3JuPmxgLSKwxbpkveYk6ANr8nHTyhbRN2RFXISyg/F2bEihuJ1APBGAniFsEX6Em28LBHUbwHYNtNI3E3twIP2RR5XmGB+wxWVgUiEk+adhzlXscrBqG47Htv9M/7EUGuJz8n/bJ7fLccJBmDM4gvOgCmOjbM=  ;
X-YMail-OSG: ydlH9gQVM1lsEL3L2YrnA_5RM8qqKY5VGbnbMNk7Bv9yzG_x59Ghfp5l79EvE1X6s3AB1ZSeH2tPYCPtqJctLaMmR6bswXcnrKHC55WQflUI7POo_mf6BmTWQ2krTQxUHlEs2dAuFNLtGuk5VTEYvw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386, bisected, reproducable)
Date: Wed, 18 Jun 2008 16:10:20 +1000
User-Agent: KMail/1.9.5
Cc: Andi Kleen <andi@firstfloor.org>, Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Ingo Molnar <mingo@elte.hu>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <48582E03.1040404@firstfloor.org> <alpine.LFD.1.10.0806171442210.2907@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806171442210.2907@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806181610.21017.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 June 2008 07:46, Linus Torvalds wrote:
> On Tue, 17 Jun 2008, Andi Kleen wrote:

> So the patch _fixes_ copy_from_user(), exactly because it says that even
> if you've loaded 24 bytes, but you faulted on the fourth load, you've
> still _copied_ exactly zero bytes, because you didn't actually store the
> 24 bytes you loaded.

Yes, the new filemap.c code does not require an exact byte count, but
it won't work if there is an under-estimation of the number of bytes
left to copy.

The old filemap.c code actually also relies on the byte count in some
cases, I can't remember off the top of my head, but I *think* it was a
security measure to prevent uninitialized data leak.

Most other cases of course only care about complete success or not, but
there are others. filemap_xip, splice are a couple that pop up.

Thanks for working that all out before I even read my email :)
