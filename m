Return-Path: <linux-kernel-owner+w=401wt.eu-S1751942AbZLVFrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbZLVFrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 00:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZLVFra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 00:47:30 -0500
Received: from mail-pz0-f198.google.com ([209.85.222.198]:48296 "EHLO
	mail-pz0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZLVFr3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 00:47:29 -0500
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Dec 2009 00:47:29 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vutar+KUvluHRkqJmD6d3l0Lc0BceiNQPwLeoN8kks9JaIpqtFzFzBPus7Zrop9Vsx
         V/GVlB3X36ELNbxLb1fZUp/hC6P5PdhtDU/jIRu8u+GPn5ZktvDb2A+4MA+MQLiV10ZT
         Jf+lAFA0VUg2qdwGSvCLNFiA2FPQWMuBQjAeA=
MIME-Version: 1.0
In-Reply-To: <1261441037.3273.254.camel@localhost>
References: <1261441037.3273.254.camel@localhost>
Date: Tue, 22 Dec 2009 13:42:13 +0800
Message-ID: <7b6bb4a50912212142i6892320q7a84cf185a4a2621@mail.gmail.com>
Subject: Re: 2.6.33-rc1 unusable due to scheduler issues, circular locking, 
	WARNs and BUGs
From: Xiaotian Feng <xtfeng@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       efault@gmx.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does a revert of cd29fe6f2637cc2ccbda5ac65f5332d6bf5fa3c6 fix this problem?

On Tue, Dec 22, 2009 at 8:17 AM, Eric Paris <eparis@redhat.com> wrote:
> Trying to build a kernel on a 48 core x86_64 box using make -j 64 and
> I'm exploding in the scheduler.  I'm running (and building) kernel
> f7b84a6ba7eaeba4e1df8feddca1473a7db369a5  There are three distinct
> signatures of problems.  Some boots I'll see all 3 of these failures
> sometimes only 1 or 2 of them.  That's the reason they are kinda split
> up in dmesg.
>
> 1) gcc/3141 is trying to acquire lock:
>  (&(&sem->wait_lock)->rlock){......}, at: [<ffffffff81223234>] __down_read_trylock+0x13/0x46
>
> but task is already holding lock:
>  (&rq->lock){-.-.-.}, at: [<ffffffff8103dd2d>] task_rq_lock+0x51/0x83
>
> 2) WARN() in kernel/sched_fair.c:1001 hrtick_start_fair()
>
> 3) NULL pointer dereference at 0000000000000168 in check_preempt_wakeup
>      kernel/sched_fair.c
>
> Full backtraces are in the attached dmesg.
>
