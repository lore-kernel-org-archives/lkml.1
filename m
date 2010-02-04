Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab0BDWbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 17:31:44 -0500
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:58771 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758422Ab0BDWbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 17:31:42 -0500
From: Frans Pop <elendil@planet.nl>
To: David Rientjes <rientjes@google.com>
Subject: Re: Improving OOM killer
Date: Thu, 4 Feb 2010 23:31:31 +0100
User-Agent: KMail/1.9.9
Cc: riel@redhat.com, l.lunak@suse.cz, balbir@linux.vnet.ibm.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       npiggin@suse.de, jkosina@suse.cz
References: <201002012302.37380.l.lunak@suse.cz> <20100203170127.GH19641@balbir.in.ibm.com> <alpine.DEB.2.00.1002031021190.14088@chino.kir.corp.google.com> <201002032355.01260.l.lunak@suse.cz> <alpine.DEB.2.00.1002031600490.27918@chino.kir.corp.google.com> <4B6A1241.60009@redhat.com> <4B6A1241.60009@redhat.com> <alpine.DEB.2.00.1002041339220.6071@chino.kir.corp.google.com>
In-reply-To: <alpine.DEB.2.00.1002041339220.6071@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002042331.34086.elendil@planet.nl>
X-OriginalArrivalTime: 04 Feb 2010 22:31:40.0920 (UTC) FILETIME=[D263CF80:01CAA5E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> It's clear that the forkbomb threshold would need to be definable from
> userspace and probably default to something high such as 1000.
> 
> Keep in mind that we're in the oom killer here, though.  So we're out of
> memory and we need to kill something; should Apache, Oracle, and postgres
> not be penalized for their cost of running by factoring in something like
> this?
> 
> (lowest rss size of children) * (# of first-generation children) /
>                    (forkbomb threshold)

Shouldn't fork bomb detection take into account the age of children?
After all, long running processes with a lot of long running children are 
rather unlikely to be runaway fork _bombs_.

Children for desktop environments are more likely to be long running than 
e.g. a server process that's being DOSed.
The goal of the OOM killer is IIUC trying to identify the process thats 
causing the immediate problem so in this example it should prefer latter.

Cheers,
FJP
