Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbZLaPsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbZLaPsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 10:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbZLaPsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 10:48:38 -0500
Received: from www84.your-server.de ([213.133.104.84]:47221 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbZLaPsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 10:48:38 -0500
Subject: Re: [PATCH] proc: revert to show stack information in
 /proc/{pid}/status
From: Stefani Seibold <stefani@seibold.net>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091231231051.1A1B.A69D9226@jp.fujitsu.com>
References: <20091231231051.1A1B.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 31 Dec 2009 16:48:14 +0100
Message-ID: <1262274494.14143.7.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 31.12.2009, 23:12 +0900 schrieb KOSAKI Motohiro:
> Commit d899bf7b (procfs: provide stack information for threads) introduced
> to show stack information in /proc/{pid}/status. But it cause large performance
> regression. Unfortunately /proc/{pid}/status is used ps command too and ps is
> one of most important component. Because both to take mmap_sem and page table walk
> are heavily operation.
> 

/proc/<pid>/status is IMHO not a performance relevant thing. The main
reason is to provide exact information about a running process.
 
> Thus, this patch revert it. Fortunately /proc/{pid}/task/{tid}/smaps
> provide almost same information. we can use it.
> 

Completely wrong. Where does smaps provides this kind of information?
Where is there the high water mark of the stack usage?

> Cc: Stefani Seibold <stefani@seibold.net>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---

Nak: Stefani Seibold <stefani@seibold.net>


