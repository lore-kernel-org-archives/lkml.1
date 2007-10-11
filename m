Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbXJKIOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbXJKIOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 04:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbXJKIN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 04:13:57 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43998 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbXJKIN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 04:13:56 -0400
Message-ID: <470DDCAC.4040302@bull.net>
Date: Thu, 11 Oct 2007 10:19:56 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Pierre Peiffer <Pierre.Peiffer@bull.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH -mm] IPC: fix error checking in all new xxx_lock()
 functions
References: <20071011100348.abc31218.Pierre.Peiffer@bull.net>
In-Reply-To: <20071011100348.abc31218.Pierre.Peiffer@bull.net>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/10/2007 10:20:14,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/10/2007 10:20:16,
	Serialize complete at 11/10/2007 10:20:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Peiffer wrote:
> In the new implementation of the [sem|shm|msg]_lock[_check]() routines,
> we use the return value of ipc_lock() in container_of() without any check.
> But ipc_lock may return a errcode. The use of this errcode in container_of()
> may alter this errcode, and we don't want this.
> 
> Today, there is no problem because the member used in these container_of()
> is the first member of its container (offset == 0), the errcode isn't changed
> then. But in the general case, we can't count on this assumption and this
> may lead later to a real bug if we don't correct this.
> 
> In fact, the proposed solution is simple and correct. But it has the drawback
> of adding one more check ('if' statement) in the chain: we do a first check in
> ipc_lock(), now in xxx_lock() and then one later in the caller of xxx_lock()
> That's why I send this as RFC, may be another approach could be considered.
> 

This is really what disturbs me this solution: the same check will be 
done several times. But is true that we have to do something.
So why not simply adding a BIG COMMENT before the msg_queue, sem_array 
and shmid_ds stating that the kern_ipc_perm should stay at the beinnign 
of the structure?

Will try to look for another solution.

Regards,
Nadia

