Return-Path: <linux-kernel-owner+w=401wt.eu-S1761601AbXEKGPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761601AbXEKGPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 02:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758333AbXEKGOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 02:14:54 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:40402 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755046AbXEKGOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 02:14:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=4ODe0HUh48bTeo99wNT7rHbN0ziqimUsPKM1bC1iJf9lHFNXMtSh+UlRGnaGrSbdvguR/LVhobp253EPquxQnsG1ZE9OmDJplFgoMcVRYNwf5w1Ht7HGU2KybYzKxo5argkgVjgBFHNpMP1++rBuW2kLnCrx8hsb3CGMyHoKdtE=  ;
X-YMail-OSG: PxR0UxkVM1nA84qAnc4cAbL3ffDid0wbrOx5XCz39h_eVyaazS5sm6FpKMFK7WRQ0QxBlB8Ojg--
Message-ID: <464409CF.4090203@yahoo.com.au>
Date: Fri, 11 May 2007 16:14:39 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: akpm@osdl.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] AFS: Implement basic file write support
References: <46425C55.6050000@yahoo.com.au> <20070508194358.27477.74888.stgit@warthog.cambridge.redhat.com> <20070508194411.27477.7552.stgit@warthog.cambridge.redhat.com> <27482.1178790992@warthog.cambridge.redhat.com>
In-Reply-To: <27482.1178790992@warthog.cambridge.redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>Why do you call SetPageUptodate when the page is not up to date?
>>That leaks uninitialised data, AFAIKS.
> 
> 
> It only seems that way.  If afs_prepare_write() is called, but doesn't return
> an error, then afs_commit_write() will be called, and it seems that the copy
> in of the data will be guaranteed not to fail by the caller.

Not only does it seem that way, it is that way :) PG_uptodate is being set
when the page is not uptodate, isn't it?


> Furthermore, afs_prepare_page() will have filled in the missing bits.
> 
> And whilst all that is going on, the page lock will be help by the caller, so
> that no-one else can access the partially complete page.

When a page is uptodate in pagecache, the generic read and nopage functions
do not take the page lock. So how are you excluding those?

-- 
SUSE Labs, Novell Inc.
