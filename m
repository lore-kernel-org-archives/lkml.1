Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab0BPJEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 04:04:53 -0500
Received: from smtp-out.google.com ([216.239.33.17]:12174 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab0BPJEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 04:04:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=nTHkq0eAGBtT31AJeZBSc5bEimaUdD9rhfXPSG9XF/jLr+oLb7kGvEcdIORQUQ5qC
	4x6FEDKNMz9BvAw3Jljpw==
Date: Tue, 16 Feb 2010 01:04:44 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 5/7 -mm] oom: replace sysctls with quick mode
In-Reply-To: <20100216141539.72EF.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002160102480.17122@chino.kir.corp.google.com>
References: <20100215170634.729E.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1002151411530.26927@chino.kir.corp.google.com> <20100216141539.72EF.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, KOSAKI Motohiro wrote:

> > > "_quick" is always bad sysctl name.
> > 
> > Why?  It does exactly what it says: it kills current without doing an 
> > expensive tasklist scan and suppresses the possibly long tasklist dump.  
> > That's the oom killer's "quick mode."
> 
> Because, an administrator think "_quick" implies "please use it always".
> plus, "quick" doesn't describe clealy meanings. oom_dump_tasks does.
> 

The audience for both of these tunables (now that oom_dump_tasks is 
default to enabled) is users with extremely long tasklists that want to 
avoid those scans, so oom_kill_quick implies that it won't waste any time 
and will act how it's documented: simply kill current and move on.
