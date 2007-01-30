Return-Path: <linux-kernel-owner+w=401wt.eu-S1751940AbXA3Xec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbXA3Xec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbXA3Xec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:34:32 -0500
Received: from gate.crashing.org ([63.228.1.57]:55851 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbXA3Xeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:34:31 -0500
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 4/4] Add support to OProfile for
	profiling Cell BE SPUs -- update
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: maynardj@us.ibm.com
Cc: linuxppc-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
       cbe-oss-dev@ozlabs.org, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <45BFCC8E.4000008@us.ibm.com>
References: <45BE4ED0.5030808@us.ibm.com> <45BE4FA4.9020105@us.ibm.com>
	 <200701300839.05144.arnd@arndb.de> <45BFBB78.7060907@us.ibm.com>
	 <45BFCC8E.4000008@us.ibm.com>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 10:34:03 +1100
Message-Id: <1170200044.26655.349.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I've given this some more thought, and I'm coming to the conclusion that 
> a pure array-based implementation for holding cached_info (getting rid 
> of the lists) would work well for the vast majority of cases in which 
> OProfile will be used.  Yes, it is true that the mapping of an SPU 
> context to a phsyical spu-numbered array location cannot be guaranteed 
> to stay valid, and that's why I discard the cached_info at that array 
> location when the SPU task is switched out.  Yes, it would be terribly 
> inefficient if the same SPU task gets switched back in later and we 
> would have to recreate the cached_info.  However, I contend that 
> OProfile users are interested in profiling one application at a time. 
> They are not going to want to muddy the waters with multiple SPU apps 
> running at the same time.  I can't think of any reason why someone would 
> conscisouly choose to do that.
> 
> Any thoughts from the general community, especially OProfile users?

Well, it's my understanding that quite a few typical usage scenario
involve different tasks running on different SPUs passing each other
data around.

Ben.


