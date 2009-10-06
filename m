Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbZJFAGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbZJFAGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbZJFAGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:06:10 -0400
Received: from smtp-out.google.com ([216.239.45.13]:35750 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263AbZJFAGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:06:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Nb68l6APJBwgEaZz76O8A9qcl+0dOTVPYpSiv8DZRX33KnSmzLIkWEuob8vfSO3hd
	yglRxP3CmIjghkfbSrC6w==
Date: Mon, 5 Oct 2009 17:04:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Frans Pop <elendil@planet.nl>
cc: Mel Gorman <mel@csn.ul.ie>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>, linux-mm@kvack.org
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
In-Reply-To: <200910052334.23833.elendil@planet.nl>
Message-ID: <alpine.DEB.1.00.0910051700440.31688@chino.kir.corp.google.com>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910050851.02056.elendil@planet.nl> <20091005085739.GB5452@csn.ul.ie> <200910052334.23833.elendil@planet.nl>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Oct 2009, Frans Pop wrote:

> And the winner is:
> 2ff05b2b4eac2e63d345fc731ea151a060247f53 is first bad commit
> commit 2ff05b2b4eac2e63d345fc731ea151a060247f53
> Author: David Rientjes <rientjes@google.com>
> Date:   Tue Jun 16 15:32:56 2009 -0700
> 
>     oom: move oom_adj value from task_struct to mm_struct
> 
> I'm confident that the bisection is good. The test case was very reliable 
> while zooming in on the merge from akpm.
> 

I doubt it for two reasons: (i) this commit was reverted in 0753ba0 since 
2.6.31-rc7 and is no longer in the kernel, and (ii) these are GFP_ATOMIC 
allocations which would be unaffected by oom killer scores.
