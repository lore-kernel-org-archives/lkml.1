Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbYCaJ5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbYCaJ5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbYCaJ5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:57:12 -0400
Received: from mga10.intel.com ([192.55.52.92]:22083 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756550AbYCaJ5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:57:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,581,1199692800"; 
   d="scan'208";a="311190327"
Message-ID: <47F0B55A.4000607@linux.intel.com>
Date: Mon, 31 Mar 2008 02:56:42 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, thomas@tungstengraphics.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <87myof8ief.fsf@basil.nowhere.org>
In-Reply-To: <87myof8ief.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

> Also it is doubtful clflush really makes sense on a large array. Just
> doing wbinvd might be faster then.

wbinvd is rarely a good idea; think about it... it'll flush 12Mb of cache *per socket* in one instruction.
(on a modern Intel consumer grade CPU, more on the enterprise ones)
This doesn't only impact the current logical thread, but ALL of the threads in the system, since the cache
coherency needs to be preserved, all have to go empty at the same time.
Forget real time... this can take really long even for non-realtime users ;)

At least clflush breaks this up into smaller pieces so total latency won't suck entirely.


