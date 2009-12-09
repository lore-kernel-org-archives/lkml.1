Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZLIHmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZLIHmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbZLIHmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:42:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:55878 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZLIHml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:42:41 -0500
Subject: Re: [PATCH 4/7] sched: implement force_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4B1F34B6.3090107@kernel.org>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
	 <1259726212-30259-5-git-send-email-tj@kernel.org>
	 <1259923259.3977.1928.camel@laptop> <1259923381.3977.1934.camel@laptop>
	 <4B1C85D3.3080401@kernel.org> <1260174900.8223.1159.camel@laptop>
	 <4B1CDA1C.3000802@kernel.org> <1260183278.8223.1500.camel@laptop>
	 <4B1CE1E8.2070803@kernel.org>  <4B1E1130.9050108@kernel.org>
	 <1260262963.3935.1002.camel@laptop>  <4B1E189B.1070204@kernel.org>
	 <1260268453.3935.1106.camel@laptop>  <4B1E378A.5050101@kernel.org>
	 <1260272885.3935.1189.camel@laptop>  <4B1E3EE0.7030001@kernel.org>
	 <1260274232.3935.1223.camel@laptop>  <4B1E4548.5040408@kernel.org>
	 <1260279351.3935.1375.camel@laptop>  <4B1F34B6.3090107@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Dec 2009 08:41:26 +0100
Message-ID: <1260344486.5489.38.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 14:25 +0900, Tejun Heo wrote:
> As for the force_cpus_allowed() bit, I think it's a rather natural
> interface to have and maybe we can replace kthread_bind() with it or
> make kthread_bind() in terms of it.  It's the basic migration function
> which adheres to the cpu hot plug/unplug synchronization rules.

I quite disagree, its quite unnatural to be adding threads to a cpu that
is about to go down or about to come up for that matter, and we most
certainly don't want to add to the hotplug rules, there are quite enough
of them already.

You could always do it from CPU_ONLINE, since they don't care about
cpu-affinity anyway (the thing was down for crying out loud), it really
doesn't matter when they're moved back if at all.

I still think its utter insanity to even consider moving them back, or
for that matter to have worklets that take minutes to complete, that's
just daft.

I think I'm going to NAK all this, it looks quite ill conceived.

