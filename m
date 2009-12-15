Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbZLOE6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbZLOE6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756573AbZLOE57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:57:59 -0500
Received: from smtp-out.google.com ([216.239.33.17]:24630 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbZLOE57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:57:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ShWQX+JB4PTCzmAAGbSzxtfBHwHaSN85DOscwk6tbkDBiOuG1wa8PTkbIM89udvsB
	NOKgjhPpX/S3f8LsZOddw==
Date: Mon, 14 Dec 2009 20:57:53 -0800 (PST)
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
In-Reply-To: <20091215134327.6c46b586.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0912142054520.436@chino.kir.corp.google.com>
References: <20091110162121.361B.A69D9226@jp.fujitsu.com> <20091110171704.3800f081.kamezawa.hiroyu@jp.fujitsu.com> <20091111112404.0026e601.kamezawa.hiroyu@jp.fujitsu.com> <20091111134514.4edd3011.kamezawa.hiroyu@jp.fujitsu.com>
 <20091111142811.eb16f062.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0911102155580.2924@chino.kir.corp.google.com> <20091111152004.3d585cee.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0911102224440.6652@chino.kir.corp.google.com>
 <20091111153414.3c263842.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0911171609370.12532@chino.kir.corp.google.com> <20091118095824.076c211f.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0911171725050.13760@chino.kir.corp.google.com>
 <20091214171632.0b34d833.akpm@linux-foundation.org> <20091215103202.eacfd64e.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0912142025090.29243@chino.kir.corp.google.com> <20091215134327.6c46b586.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009, KAMEZAWA Hiroyuki wrote:

> > That's not at all what I said.  I said using total_vm as a baseline allows 
> > users to define when a process is to be considered "rogue," that is, using 
> > more memory than expected.  Using rss would be inappropriate since it is 
> > highly dynamic and depends on the state of the VM at the time of oom, 
> > which userspace cannot possibly keep updated.
> > 
> > You consistently ignore that point: the power of /proc/pid/oom_adj to 
> > influence when a process, such as a memory leaker, is to be considered as 
> > a high priority for an oom kill.  It has absolutely nothing to do with 
> > fake NUMA, cpusets, or memcg.
> > 
> You also ignore that it's not sane to use oom kill for resource control ;)
> 

Please read my email.  Did I say anything about resource control AT ALL?  
I said /proc/pid/oom_adj currently allows userspace to define when a task 
is "rogue," meaning its consuming much more memory than expected.  Those 
memory leakers should always be the optimal result for the oom killer to 
kill.  Using rss as the baseline would not allow userspace to effectively 
do the same thing since it's dynamic and depends on the state of the VM at 
the time of oom which is probably not reflected in the /proc/pid/oom_adj 
values for all tasks.  It has absolutely nothing to do with resource 
control, so please address this very trivial issue without going off on 
tangents.  Thanks.
