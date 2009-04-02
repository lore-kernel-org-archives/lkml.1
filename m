Return-Path: <linux-kernel-owner+w=401wt.eu-S932225AbZDBLNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbZDBLNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762204AbZDBLMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:12:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50926 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbZDBLMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:12:50 -0400
Subject: Re: [RFC] Improving scheduler for asymmetric multi-core processor
 in  Google's summer of code
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <h.mitake@gmail.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
In-Reply-To: <a6b9f31a0904010758r23767adco16ea4ee45d7e158e@mail.gmail.com>
References: <a6b9f31a0904010758r23767adco16ea4ee45d7e158e@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 02 Apr 2009 13:13:46 +0200
Message-Id: <1238670826.8530.5837.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-01 at 23:58 +0900, Hitoshi Mitake wrote:
> Hi,
> 
> I found an interesting problem, scheduling on Asymmetric multi-core processor.
> 
> According to this paper,
> 
> http://portal.acm.org/citation.cfm?id=1362694&dl=GUIDE&coll=GUIDE&CFID=28487975&CFTOKEN=68150071
> 
> taking performance asymmetry into consideration on multi-core CPUs can
> improve scheduler performance.
> (And I think discarding this could have bad consequences.)
> 
> So I have a question:
> Is the current scheduler of Linux aware of possible performance
> asymmetry of the cores?

It does not.

> By performance asymmetry I mean a case where different cores run on
> different frequencies.
> 
> If something tackling this issue is not implemented yet,
> I would like to work on that as a project of Google's summer of code.

Have at it. 

Its a rather delicate business though and should also include scaling
balancing decisions based on time taken by IRQs and RT tasks as well as
incorporate feedback from the cpu. The latter includes things like
cpufreq, but also effective work done by threads on a core.

Its been on my todo list for quite a while, but haven't managed to get
something robust together.
