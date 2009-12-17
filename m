Return-Path: <linux-kernel-owner+w=401wt.eu-S964810AbZLQWXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbZLQWXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 17:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935012AbZLQWXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 17:23:47 -0500
Received: from smtp-out.google.com ([216.239.33.17]:26311 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934561AbZLQWXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 17:23:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=qzbOtQACkghbVjFnFeCHr+GqXkK5+si1tJ32nW6lOlyFdtDop60p5D1Cmb5UsXh8P
	qNJMfBoLi6imwmcod/okg==
Date: Thu, 17 Dec 2009 14:23:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with nodemask
 v4.2
In-Reply-To: <20091215140913.e28f7674.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0912171422290.4089@chino.kir.corp.google.com>
References: <20091110162121.361B.A69D9226@jp.fujitsu.com> <20091111134514.4edd3011.kamezawa.hiroyu@jp.fujitsu.com> <20091111142811.eb16f062.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0911102155580.2924@chino.kir.corp.google.com>
 <20091111152004.3d585cee.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0911102224440.6652@chino.kir.corp.google.com> <20091111153414.3c263842.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0911171609370.12532@chino.kir.corp.google.com>
 <20091118095824.076c211f.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0911171725050.13760@chino.kir.corp.google.com> <20091214171632.0b34d833.akpm@linux-foundation.org> <20091215103202.eacfd64e.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.0912142025090.29243@chino.kir.corp.google.com> <20091215134327.6c46b586.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0912142054520.436@chino.kir.corp.google.com> <20091215140913.e28f7674.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009, KAMEZAWA Hiroyuki wrote:

> What I can't undestand is the technique to know whether a (unknown) process is
> leaking memory or not by checking vm_size.

Memory leaks are better identified via total_vm since leaked memory has a 
lower probability of staying resident in physical memory.
