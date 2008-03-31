Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbYCaQKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbYCaQKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 12:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYCaQKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 12:10:30 -0400
Received: from mga10.intel.com ([192.55.52.92]:38392 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751710AbYCaQK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 12:10:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,583,1199692800"; 
   d="scan'208";a="311280426"
Message-ID: <47F10C62.7040500@linux.intel.com>
Date: Mon, 31 Mar 2008 09:08:02 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
CC: Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <87myof8ief.fsf@basil.nowhere.org> <47F098E8.1050605@tungstengraphics.com> <20080331083816.GC29105@one.firstfloor.org> <47F0A988.7010707@tungstengraphics.com> <20080331091829.GD29105@one.firstfloor.org> <47F0C6C2.2000004@tungstengraphics.com>
In-Reply-To: <47F0C6C2.2000004@tungstengraphics.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Hellström wrote:

> Let me rehprase. Not really time-critical but it is of some importance 
> that CPA is done quickly.
> We're dealing with the tradeoff of reading from uncached device memory 

uncached or write combining ?

> vs taking the pages out of
> AGP, setting up a cache-coherent mapping, read and then change back. 
> What we'd really would like to set up is a pool of completely unmapped 
> (like highmem) pages. Then we could, to a large extent, avoid the CPA 
> calls.

changing attributes by nature means a tlb flush and a bunch of expensive cache work.
That's never going to be cheap, I guess it all depends on how much work you do
on the memory for it to pay off or not...
