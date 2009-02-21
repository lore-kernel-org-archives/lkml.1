Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbZBUHeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbZBUHeD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 02:34:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZBUHdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 02:33:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:37971 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbZBUHdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 02:33:52 -0500
Message-ID: <499FAE55.8070801@kernel.org>
Date: Sat, 21 Feb 2009 16:33:41 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com
Subject: Re: [PATCHSET x86/core/percpu] implement dynamic percpu allocator
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <499CA834.4080208@kernel.org> <20090219110718.GK2354@elte.hu> <499E20BC.4020408@kernel.org> <20090220093234.GF24555@elte.hu> <499FA8D1.8030806@kernel.org>
In-Reply-To: <499FA8D1.8030806@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 21 Feb 2009 07:33:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> I can remove the TLB problem from non-NUMA case but for NUMA I still
> don't have a good idea.  Maybe we need to accept the overhead for
> NUMA?  I don't know.

Hmmmm... one thing we can do on NUMA is to remap and free the remapped
address and make __pa() and __va() handle that area specially.  It's a
bit convoluted but the added overhead should be minimal.  It'll only
be simple range check in __pa()/__va() and it's not like they are
super hot paths anyway.  I'll give it a shot.

Thanks.

-- 
tejun
