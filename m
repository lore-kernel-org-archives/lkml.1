Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYCKNq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYCKNq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 09:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYCKNqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 09:46:21 -0400
Received: from sacred.ru ([62.205.161.221]:41948 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbYCKNqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 09:46:20 -0400
Message-ID: <47D68D1B.1040901@openvz.org>
Date: Tue, 11 Mar 2008 16:46:03 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, trond.myklebust@fys.uio.no
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [NFS]: Lock daemon start/stop rework.
References: <1201693294-11460-1-git-send-email-den@openvz.org> <20080131033320.GA15067@infradead.org>
In-Reply-To: <20080131033320.GA15067@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 11 Mar 2008 16:46:00 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Jan 30, 2008 at 02:41:34PM +0300, Denis V. Lunev wrote:
>> The pid of the locking daemon can be substituted with a task struct
>> without a problem. Namely, the value if filled in the context of the lockd
>> thread and used in lockd_up/lockd_down.
>>
>> It is possible to save task struct instead and use it to kill the process.
>> The safety of this operation is guaranteed by the RCU, i.e. task can't
>> disappear without passing a quiscent state.
> 
> We have a patch series pending on the nfs list that does this plus a lot
> more in the area.
> 

Sorry for bringing it up that late, but I haven't found any patches doing
the same for nfs/callback.c. What are the plans about this code? Can we 
start turning this to kthreads? Or is there some grand rework pending in 
this code, so that we will just duplicate someone's work or cause unneeded 
patches conflicts?

You see, this code is the last user of kill_proc(), which in turn is the
last user of find_pid() which (in turn) is about to be removed.

Thanks,
Pavel
