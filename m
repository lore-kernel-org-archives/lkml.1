Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbYJDUw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbYJDUw6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 16:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbYJDUwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 16:52:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:13300 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbYJDUwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 16:52:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=knSAdpq4CEG2ZblNl6wdw+ur47ihjNZqeDRScxWZVJsaVNBBD9fMFMVBphmIc+PMSa
         5L9OtqOl22B3WiqyPHqlH8U+szY8X0HuBZ8ivCAWCy+20abBWiYFi21/UWR8UK3ePSYt
         fmouuUDcnh1mjRMgnHy4RgGDmiTNomNcLtiS0=
Date: Sun, 5 Oct 2008 00:55:22 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Oleg Nesterov <oleg@tv-sign.ru>, Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] signal, procfs: lock_task_sighand() do not need
	rcu_read_lock()
Message-ID: <20081004205522.GA4259@x200.localdomain>
References: <48E5ED4D.4030102@cn.fujitsu.com> <20081003162915.GA624@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003162915.GA624@tv-sign.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 08:29:15PM +0400, Oleg Nesterov wrote:
> On 10/03, Lai Jiangshan wrote:
> >
> > lock_task_sighand() make sure task->sighand is being protected,
> > so we do not need rcu_read_lock().
> > [ exec() will get task->sighand->siglock before change task->sighand! ]
> >
> > But code using rcu_read_lock() _just_ to protect lock_task_sighand()
> > only appear in procfs. (and some code in procfs use lock_task_sighand()
> > without such redundant protection.)
> 
> Yes, the patch looks correct.

Yeah, applied to proc.git
