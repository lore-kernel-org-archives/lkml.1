Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbZGKTR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbZGKTR5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 15:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZGKTRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 15:17:50 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35059 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbZGKTRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 15:17:50 -0400
Date: Sat, 11 Jul 2009 12:18:16 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@dmesg.printk.net,
       Containers <containers@lists.linux-foundation.org>
Subject: Re: fanotify: the fscking all notification system
Message-ID: <20090711191816.GA5222@us.ibm.com>
References: <1246306125.754.300.camel@dhcp235-23.rdu.redhat.com> <20090701041039.GB23013@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701041039.GB23013@count0.beaverton.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| > struct fanotify_event_metadata {
| >         __u32 event_len;
| >         __s32 fd;
| >         __u32 mask;
| >         __u32 f_flags;
| >         pid_t pid;
| >         pid_t tgid;
| >         __u64 cookie;
| > }  __attribute__((packed));
| 
| Since it passes pids from the kernel to userspace via a socket I suspect
| this needs input from the folks working on pid namespaces. The events may
| need to be dropped if the pid namespace of the event's origin doesn't
| match that of the destination. Otherwise the pid would be ambiguous and
| this interface will only work for tasks in the initial pid namespace.

If we do have the destination pid namespace, we could translate the pid
of the process modifying the file, into the pid namespace of the process
receiving the notification, like we do in mq_notify().

So when a process in an ancestor or unrelated pid namespace modifies the
file, the si_pid would get set to 0. 

Sukadev
