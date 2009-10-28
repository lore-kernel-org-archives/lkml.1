Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbZJ1GRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbZJ1GRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbZJ1GRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:17:45 -0400
Received: from smtp-out.google.com ([216.239.45.13]:43487 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391AbZJ1GRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:17:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=aa3QuVj4DAt8a/C+OJ1+epWE0kJTdjpVILeqxC616vE5k565YzZ08H7yMOoBc9y2l
	5RN6njKR2gUwHRUjK++7A==
Date: Tue, 27 Oct 2009 23:17:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
In-Reply-To: <20091028150536.674abe68.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0910272311001.15462@chino.kir.corp.google.com>
References: <hav57c$rso$1@ger.gmane.org> <20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com> <hb2cfu$r08$2@ger.gmane.org> <20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com> <4ADE3121.6090407@gmail.com> <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>
 <4AE5CB4E.4090504@gmail.com> <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0910271843510.11372@sister.anvils> <alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com> <4AE78B8F.9050201@gmail.com>
 <alpine.DEB.2.00.0910271723180.17615@chino.kir.corp.google.com> <4AE792B8.5020806@gmail.com> <alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com> <20091028135519.805c4789.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910272205200.7507@chino.kir.corp.google.com>
 <20091028150536.674abe68.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009, KAMEZAWA Hiroyuki wrote:

> All kernel engineers know "than expected or not" can be never known to the kernel.
> So, oom_adj workaround is used now. (by some special users.)
> OOM Killer itself is also a workaround, too.
> "No kill" is the best thing but we know there are tend to be memory-leaker on bad
> systems and all systems in this world are not perfect.
> 

Right, and historically that has been addressed by considering total_vm 
and adjusting it with oom_adj so that we can identify memory leaking tasks 
through user-defined criteria.

> Yes, some more trustable values other than vmsize/rss/time are appriciated.
> I wonder recent memory consumption speed can be an another key value.
> 

Sounds very logical.

> Anyway, current bahavior of "killing X" is a bad thing.
> We need some fixes.
> 

You can easily protect X with OOM_DISABLE, as you know.  I don't think we 
need any X-specific heuristics added to the kernel, it looks like the 
special cases have already polluted badness() enough.
