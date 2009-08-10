Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbZHJWZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbZHJWZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 18:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbZHJWZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 18:25:37 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:39764 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbZHJWZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 18:25:34 -0400
Date: Mon, 10 Aug 2009 15:26:19 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>, serue@us.ibm.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Containers <containers@lists.linux-foundation.org>,
       sukadev@us.ibm.com
Subject: Re: [RFC][v4][PATCH 7/7]: Define clone_with_pids syscall
Message-ID: <20090810222619.GA4805@us.ibm.com>
References: <20090807061103.GA19343@us.ibm.com> <20090807061517.GG20672@us.ibm.com> <20090810145425.GA1378@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810145425.GA1378@ucw.cz>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek [pavel@ucw.cz] wrote:
| Hi!
| 
| > 
| > Subject: [RFC][v4][PATCH 7/7]: Define clone_with_pids syscall
| > 
| > Container restart requires that a task have the same pid it had when it was
| > checkpointed. When containers are nested the tasks within the containers
| > exist in multiple pid namespaces and hence have multiple pids to specify
| > during restart.
| > 
| > clone_with_pids(), intended for use during restart, is the same as clone(),
| > except that it takes a 'target_pid_set' paramter. This parameter lets caller
| > choose specific pid numbers for the child process, in the process's active
| > and ancestor pid namespaces. (Descendant pid namespaces in general don't
| > matter since processes don't have pids in them anyway, but see comments
| > in copy_target_pids() regarding CLONE_NEWPID).
| 
| This should go to documentation/manpage somewhere.

Agree. Will update once we have some consensus on the interface.

The interface defined in this patch 7/7 

	syscall(__NR_clone_with_pids, flags, stack, NULL, NULL, NULL, &pid_set);

meets the requirements of checkpoint/restart. But as mentioned in patch 0/7,
we are just not sure if we should take this opportunity to address the
clone-flags limitation so we are not forced to define another flavor of
clone() soon.

Sukadev
