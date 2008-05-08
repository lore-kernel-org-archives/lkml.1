Return-Path: <linux-kernel-owner+w=401wt.eu-S1764342AbYEHPAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764342AbYEHPAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbYEHO7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 10:59:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763540AbYEHO7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 10:59:20 -0400
Date: Thu, 8 May 2008 07:58:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <1210221436.3453.98.camel@ymzhang>
Message-ID: <alpine.LFD.1.10.0805080754310.3024@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang>  <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org>  <20080506162332.GI19219@parisc-linux.org>  <1210217099.3453.92.camel@ymzhang>  <alpine.LFD.1.10.0805072030480.3024@woody.linux-foundation.org>
 <1210221436.3453.98.camel@ymzhang>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 May 2008, Zhang, Yanmin wrote:
>
> I collected oprofile data. It looks not useful, as cpu idle is more than 50%.

Ahh, so it's probably still the BKL that is the problem, it's just not in 
the file locking code. The changes to fs/locks.c probably didn't matter 
all that much, and the additional regression was likely just some 
perturbation.

So it's probably fasync that AIM7 tests. Quite possibly coupled with 
/dev/tty etc. No file locking.

			Linus
