Return-Path: <linux-kernel-owner+w=401wt.eu-S1764553AbZDATeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764553AbZDATeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933874AbZDATd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:33:58 -0400
Received: from smtp-out.google.com ([216.239.33.17]:25046 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763139AbZDATd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:33:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=pF7r7RPCUWt+zhk0MIeONWazY00I//UXpG5N9UvS5jD+ktUy6902Ui6MxXDIi/91m
	Y3OKwC9DBOf83k1ERLciw==
Date: Wed, 1 Apr 2009 12:33:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Trilok Soni <soni.trilok@gmail.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Greg KH <greg@kroah.com>,
       Paul Mundt <lethal@linux-sh.org>, Arve Hj?nnev?g <arve@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       Brian Swetland <swetland@google.com>, arve@google.com,
       San Mehat <san@android.com>, Robert Love <rlove@google.com>,
       linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       ext Juha Yrj?l? <juha.yrjola@solidboot.com>, viktor.rosendahl@nokia.com
Subject: Re: lowmemory android driver not needed?
In-Reply-To: <5d5443650904011138p78686bf7oc040762cd3536387@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0904011226350.31960@chino.kir.corp.google.com>
References: <2f11576a0901160316u20030f4u51c9e4c059398b70@mail.gmail.com>  <20090116152338.GB9357@kroah.com>  <20090122114955.32F3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <5d5443650904011138p78686bf7oc040762cd3536387@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009, Trilok Soni wrote:

> Any updates on top of  mem_notify v6 patches?  Is there any WIP for
> mem_notify with memcg infrastructure as you have pointed out above?
> 

The /dev/mem_notify patches seem to have been abandoned, but there's still 
an interest in a per-cgroup oom notifier.  This shouldn't be restricted 
only to the memory controller, however, since cpusets could use the 
feature as well.  Thus, it should probably be its own cgroup.

Implementing the same concept as /dev/mem_notify on top of the cgroup 
interface would probably require some hacking to support such files, but 
that support may not be far off anyway (devices that are only accessible 
by an exclusive group of tasks).
