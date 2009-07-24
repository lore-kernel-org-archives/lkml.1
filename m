Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbZGYRzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbZGYRzJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 13:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZGYRzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 13:55:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:42910 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZGYRzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 13:55:07 -0400
Date: Fri, 24 Jul 2009 07:28:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: sen wang <wangsen.linux@gmail.com>
Cc: mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: report a bug about sched_rt
Message-ID: <20090724072826.4c35bc2a@infradead.org>
In-Reply-To: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>
References: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009 18:57:35 +0800
sen wang <wangsen.linux@gmail.com> wrote:

> I find something is wrong about sched_rt.
> 
>  when I am debugging my system with rt_bandwidth_enabled, there is a
> running realtime FIFO task in the sched_rt running queue and
>  the fair running queue is empty.  I found the idle task will be
> scheduled up when the running task still lie in the  sched_rt running
> queue!
> 
> this will happen when rt runqueue passed it's rt_bandwidth_enabled
> runtime,then the scheduler choose the idle task instead of realtime
> FIFO task.
> 
> the reason lie in: when scheduler try to pick up a realtime FIFO task,
> it will check if rt_throttled is enabled,
> if so, it'll return and try fair queue but it is empty, then it come
> to the sched_idle class.
> 
> I don't think it reasonable, we should give the realtime FIFO task the
> chance, even when rt runqueue passed it's runtime.
> because it is cpu's free time.


sounds like a good power limiting feature...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
