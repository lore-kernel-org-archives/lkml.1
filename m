Return-Path: <linux-kernel-owner+w=401wt.eu-S1760687AbYGQR3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbYGQR3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757493AbYGQR3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:29:36 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:32893 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409AbYGQR3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:29:35 -0400
Date: Thu, 17 Jul 2008 21:32:54 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Daniel Hokka Zakrisson <daniel@hozac.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, ebiederm@xmission.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] signals: kill(-1) should only signal processes in the same namespace
Message-ID: <20080717173254.GA20948@tv-sign.ru>
References: <487F5D6B.1090007@hozac.com> <487F5EDB.1000008@openvz.org> <43011.192.168.102.6.1216308280.squirrel@intranet> <487F6B2E.40101@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487F6B2E.40101@openvz.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17, Pavel Emelyanov wrote:
>
> Daniel Hokka Zakrisson wrote:
> > 
> > The way zap_pid_ns_processes does it is worse, since it signals every
> > thread in the namespace rather than every thread group. So either we walk
> 
> It's questionable whether there are more "threads in a pid namespace" than
> "processes in a system".
> 
> E.g. on my notebook there are ~110 processes and ~150 threads. So having 
> this setup launched in 10 containers you'll have to walk 1100 tasks, while
> zap_pid_ns_processes only 150 ;)
> 
> Some real-life example with containers: on one of our servers with 10 
> containers serving as git repo, bulding system and some other stuff there 
> are ~200 process totally and ~20 threads in each container. See?
> 
> I tend to believe that walking threads in a container is cheaper then
> walking processes in a system...

kill_something_info() can't walk threads, think about the realtime signals.

Anyway, I think we should change kill_something_info(-1) to use rcu_read_lock()
instead of tasklist.

Oleg.

