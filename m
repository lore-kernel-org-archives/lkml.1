Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab0BDWHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 17:07:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab0BDWHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 17:07:38 -0500
Message-ID: <4B6B4500.3010603@redhat.com>
Date: Thu, 04 Feb 2010 17:06:56 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Lubos Lunak <l.lunak@suse.cz>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Improving OOM killer
References: <201002012302.37380.l.lunak@suse.cz> <20100203170127.GH19641@balbir.in.ibm.com> <alpine.DEB.2.00.1002031021190.14088@chino.kir.corp.google.com> <201002032355.01260.l.lunak@suse.cz> <alpine.DEB.2.00.1002031600490.27918@chino.kir.corp.google.com> <4B6A1241.60009@redhat.com> <alpine.DEB.2.00.1002041339220.6071@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1002041339220.6071@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2010 04:48 PM, David Rientjes wrote:

> Keep in mind that we're in the oom killer here, though.  So we're out of
> memory and we need to kill something; should Apache, Oracle, and postgres
> not be penalized for their cost of running by factoring in something like
> this?

No, they should not.

The goal of the OOM killer is to kill some process, so the
system can continue running and automatically become available
again for whatever workload the system was running.

Killing the parent process of one of the system daemons does
not achieve that goal, because you now caused a service to no
longer be available.

