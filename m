Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbYGQSVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbYGQSVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756566AbYGQSVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:21:41 -0400
Received: from proxy3.bredband.net ([195.54.101.73]:39510 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397AbYGQSVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:21:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqczAC8qf0jVchRXPGdsb2JhbACBWZBaAQEBAS0Bnjc
Message-ID: <49797.192.168.102.6.1216318897.squirrel@intranet>
In-Reply-To: <m14p6ov1j0.fsf@frodo.ebiederm.org>
References: <487F5DA1.6000107@hozac.com>
    <m14p6ov1j0.fsf@frodo.ebiederm.org>
Date: Thu, 17 Jul 2008 20:21:37 +0200 (CEST)
Subject: Re: [PATCH 2/2] signals: replace p->pid == 1 check with a check 
     for task_child_reaper
From: "Daniel Hokka Zakrisson" <daniel@hozac.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       oleg@tv-sign.ru, xemul@openvz.org, akpm@linux-foundation.org
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Daniel Hokka Zakrisson <daniel@hozac.com> writes:
>
>> p->pid == 1 is insufficient when there are multiple pid namespaces.
>> Instead, check whether the task is in the current task's
>> child reaper's thread group.
>
> We should just drop the check for init as it is redundant.

I'm not sure what you mean? Without protecting init here, kill -s 9 -- -1
will kill it (i.e. the init in the pid namespace). E.g.:
# vspace --new --pid --mount -- bash
# bash -c 'kill -s 9 -- -1'
will kill off all those processes, and dispose of the pid namespace.

> Eric

-- 
Daniel Hokka Zakrisson
