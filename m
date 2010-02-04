Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab0BDASb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 19:18:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab0BDASa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 19:18:30 -0500
Message-ID: <4B6A1241.60009@redhat.com>
Date: Wed, 03 Feb 2010 19:18:09 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Lubos Lunak <l.lunak@suse.cz>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Improving OOM killer
References: <201002012302.37380.l.lunak@suse.cz> <20100203170127.GH19641@balbir.in.ibm.com> <alpine.DEB.2.00.1002031021190.14088@chino.kir.corp.google.com> <201002032355.01260.l.lunak@suse.cz> <alpine.DEB.2.00.1002031600490.27918@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1002031600490.27918@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2010 07:05 PM, David Rientjes wrote:
> On Wed, 3 Feb 2010, Lubos Lunak wrote:

>>> 		/* Forkbombs get penalized 10% of available RAM */
>>> 		if (forkcount>  500)
>>> 			points += 100;

> Do you have any comments about the forkbomb detector or its threshold that
> I've put in my heuristic?  I think detecting these scenarios is still an
> important issue that we need to address instead of simply removing it from
> consideration entirely.

I believe that malicious users are best addressed in person,
or preemptively through cgroups and rlimits.

Having a process with over 500 children is quite possible
with things like apache, Oracle, postgres and other forking
daemons.

Killing the parent process can result in the service
becoming unavailable, and in some cases even data
corruption.

-- 
All rights reversed.
