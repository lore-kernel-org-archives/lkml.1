Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbZG1GOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbZG1GOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 02:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbZG1GOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 02:14:23 -0400
Received: from smtp-out.google.com ([216.239.33.17]:28424 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZG1GOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 02:14:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=gaWiGuISeXCzAdVbTWYNi+Zq/TMsHIh+AcQxM8BIeX68CfpKz10mXAMDrUl8QuFcE
	kTa/7mO4AapcMsN+isf4w==
Date: Mon, 27 Jul 2009 23:14:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Paul Menage <menage@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] copy over oom_adj value at fork time
In-Reply-To: <20090728120822.D80C.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907272311370.26430@chino.kir.corp.google.com>
References: <20090724083802.1E37.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0907240227070.32622@chino.kir.corp.google.com> <20090728120822.D80C.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009, KOSAKI Motohiro wrote:

> Actually, if we assume the administrator is really stupid, he can mark
> all processes as OOM_DISABLE. it makes livelock anyway.

Wrong, the oom killer will panic the machine if there are no eligible 
tasks to kill.  That's actually a more desirable result in most 
circumstances over livelocking.

> ITOH, we never seen this livelock on vfork()ed application.
> 

I have, which is why I wrote my patches.

> More important thing is: Documentation/filesysmtem/proc/txt says
> oom_adj is process property and vfork()ed parent and child are definitelly
> another process.
> 

I've proposed adding /proc/pid/oom_adj_child so that newly initialized 
mm's start with a default oom_adj value.  Paul suggested that it be a 
per-task characteristic, so that's what I'm looking at implementing.

Thanks.
