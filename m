Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbZJLSAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbZJLSAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757426AbZJLSAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:00:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60326 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042AbZJLSAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:00:45 -0400
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: arun@linux.vnet.ibm.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [v8 PATCH 2/8]: cpuidle: implement a list based approach to register a set of idle routines.
From: Andi Kleen <andi@firstfloor.org>
References: <20091008094828.GA20595@linux.vnet.ibm.com>
	<20091008095027.GC20595@linux.vnet.ibm.com>
	<1254998162.26976.270.camel@twins>
	<20091008104249.GJ20595@linux.vnet.ibm.com>
	<1254999033.26976.272.camel@twins>
Date: Mon, 12 Oct 2009 20:00:05 +0200
In-Reply-To: <1254999033.26976.272.camel@twins> (Peter Zijlstra's message of "Thu, 08 Oct 2009 12:50:33 +0200")
Message-ID: <8763akh4re.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
>
> So does it make sense to have a set of sets?
>
> Why not integrate them all into one set to be ruled by this governor
> thing?

cpuidle is currently optional, that is why the two level hierarchy
is there so that you can still have simple idle selection without it.

% size drivers/cpuidle/*.o
   text    data     bss     dec     hex filename
   5514    1416      44    6974    1b3e drivers/cpuidle/built-in.o

Adding it unconditionally would add ~7k to everyone who wants idle functions.

I think making it unconditional would require putting it on a serious
diet first.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
