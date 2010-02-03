Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab0BCRBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:01:35 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:57216 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569Ab0BCRBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:01:34 -0500
Date: Wed, 3 Feb 2010 22:31:27 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: Lubos Lunak <l.lunak@suse.cz>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Improving OOM killer
Message-ID: <20100203170127.GH19641@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <201002012302.37380.l.lunak@suse.cz>
 <4B698CEE.5020806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4B698CEE.5020806@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel <riel@redhat.com> [2010-02-03 09:49:18]:

> On 02/01/2010 05:02 PM, Lubos Lunak wrote:
> 
> >  In other words, use VmRSS for measuring memory usage instead of VmSize, and
> >remove child accumulating.
> 
> I agree with removing the child accumulating code.  That code can
> do a lot of harm with databases like postgresql, or cause the
> system's main service (eg. httpd) to be killed when a broken cgi
> script used up too much memory.
>
> IIRC the child accumulating code was introduced to deal with
> malicious code (fork bombs), but it makes things worse for the
> (much more common) situation of a system without malicious
> code simply running out of memory due to being very busy.
>

For fork bombs, we could do a number of children number test and have
a threshold before we consider a process and its children for
badness().

> I have no strong opinion on using RSS vs VmSize.
> 

David commented and feels strongly about RSS and prefers VmSize.

-- 
	Balbir
