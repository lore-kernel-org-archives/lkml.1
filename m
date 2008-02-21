Return-Path: <linux-kernel-owner+w=401wt.eu-S1765662AbYBVDSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765662AbYBVDSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 22:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbYBVDRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 22:17:55 -0500
Received: from n7b.bullet.sp1.yahoo.com ([69.147.64.166]:25625 "HELO
	n7b.bullet.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754325AbYBVDRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 22:17:54 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2008 22:17:54 EST
X-yahoo-newman-spamcop: yes
X-Yahoo-Newman-Id: 686907.78367.bm@omp418.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=d60r/DKOFd+iDsWZfuYDee2IBtoBrebC3Q18HP+1Lyt1a3h8vsIm0RCvnJZsns8p/F7uIQCkFvsRsnRuJ1KiczhIf6XeyNf9ipblO24YIhP1LfBewvb+AKSNjHjUVdwPiztfkOTb7oX2PXp4c/lUc1VXfZad2wIVfHjNsibWhcE=  ;
X-YMail-OSG: ZCnwtloVM1k2aSTXqfUZhCAiUCyG6ykPUbq_hyurR8uKzC79i0P4YuhKRSLo25Kz3ZR2zsZWZ_kbo7_H00b2ciizccxe4PBmOh2ar_.Z34kGdh6Pqww-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller in Kconfig
Date: Thu, 21 Feb 2008 15:35:38 +1100
User-Agent: KMail/1.9.5
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20080220122338.GA4352@basil.nowhere.org> <47BC2275.4060900@linux.vnet.ibm.com>
In-Reply-To: <47BC2275.4060900@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802211535.38932.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2008 23:52, Balbir Singh wrote:
> Andi Kleen wrote:
> > Document huge memory/cache overhead of memory controller in Kconfig
> >
> > I was a little surprised that 2.6.25-rc* increased struct page for the
> > memory controller.  At least on many x86-64 machines it will not fit into
> > a single cache line now anymore and also costs considerable amounts of
> > RAM.
>
> The size of struct page earlier was 56 bytes on x86_64 and with 64 bytes it
> won't fit into the cacheline anymore? Please also look at
> http://lwn.net/Articles/234974/

BTW. We'll probably want to increase the width of some counters
in struct page at some point for 64-bit, so then it really will
go over with the memory controller!

Actually, an external data structure is a pretty good idea. We
could probably do it easily with a radix tree (pfn->memory
controller). And that might be a better option for distros.

