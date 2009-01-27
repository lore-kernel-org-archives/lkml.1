Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbZA0UnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbZA0UnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 15:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZA0UnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 15:43:05 -0500
Received: from smtp-out.google.com ([216.239.33.17]:52323 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZA0UnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 15:43:02 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=MM7G10OCxzCuYkmvpP8PxDRCO8uwTLObY4gMpm7PlvjEKQQljFNZxFTeT6dqWyn1Z
	CsIbTwkTthIdULTCIR4Kw==
Date: Tue, 27 Jan 2009 12:41:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, balbir@linux.vnet.ibm.com,
       Nikanth Karthikesan <knikanth@suse.de>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Torvalds <torvalds@linux-foundation.org>,
       Arve Hj?nnev?g <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Paul Menage <menage@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
In-Reply-To: <20090127134559.GB18119@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901271238090.21124@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0901262350110.14525@chino.kir.corp.google.com> <20090127093105.GB2646@ioremap.net> <20090127193058.D48B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090127134559.GB18119@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.25.146.78
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, Evgeniy Polyakov wrote:

> Having some special application which will monitor /dev/mem_notify and
> kill processes based on its own hueristics is a good idea, but when it
> fails to do its work (or does not exist) system has to have ability to
> make a progress and invoke a main oom-killer.
> 

Agreed, very similiar to the cgroup oom notifier patch that invokes the 
oom killer if there are no attached tasks waiting to handle the situation. 

In this case, it would be a configurable delay to allow userspace to act 
in response to oom conditions before invoking the kernel oom killer.  So 
instead of thinking of this as a userspace replacement for the oom killer, 
it simply preempts it if userspace can provide more memory, including the 
possibility of killing tasks itself.
