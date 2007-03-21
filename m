Return-Path: <linux-kernel-owner+w=401wt.eu-S932893AbXCUHgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbXCUHgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 03:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933001AbXCUHgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 03:36:10 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:34087 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932936AbXCUHgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 03:36:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=mGorvfWuFEHQXf6Ga4/Mh1/t5ytiytddtyKxRtEArupOfkwodxPzvZeHAFY+akk2mlq4kWxXudHdTml91iR2x9girIPyxtsQQXUpCsgbwaYbpFCrfvG1xuDgJNSwbB/TUoUC5eBBkHEUX8FmCEqPi1Tky2PgpmFkDrvksO3KW1A=  ;
X-YMail-OSG: 8ANqw9oVM1l3b9hPFraLs1_SjKRYI1BjF2SPl.EBa2S7SPaMezp4G2jqABce1R1KqvcjN3ryF_vcHLFgmImbpsCJ9WgYx0pe9CAKceh.yfTIbWfWY5kulgsOzeuSITvEI6GFiU9NaqXe95U-
Message-ID: <4600E062.8020001@yahoo.com.au>
Date: Wed, 21 Mar 2007 18:36:02 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: William Lee Irwin III <wli@holomorphy.com>, Adam Litke <agl@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/7] Introduce the pagetable_operations and associated
 helper macros.
References: <20070319200502.17168.17175.stgit@localhost.localdomain> <20070319200513.17168.52238.stgit@localhost.localdomain> <4600B216.3010505@yahoo.com.au> <20070321045214.GE2986@holomorphy.com> <4600BD9F.8030609@yahoo.com.au> <20070321054102.GF2986@holomorphy.com> <4600D5EB.90507@yahoo.com.au>
In-Reply-To: <4600D5EB.90507@yahoo.com.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:

> Yeah you could, but it looks back to front to me.
> 
> The VM tells the filesystem that the machine took a fault at virtual
> address X, then the filesystem asks the VM what pgoff that is, then
> tells the VM to install the corresponding page to vaddr X.
> 
> With my ->fault, the VM asks the filesystem to give the page that
> corresponds to vaddr X, then installs it into that vaddr.

Err, sorry, that's what the current ->nopage does. It is then still
up to the filesystem to do the vaddr to pgoff conversion.

My fault patches of course just ask the filesystem for the page at
a given pgoff.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
