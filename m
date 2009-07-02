Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbZGBPCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbZGBPCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZGBPCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:02:45 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:40181 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbZGBPCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:02:45 -0400
Date: Thu, 2 Jul 2009 17:02:46 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, malware-list@dmesg.printk.net
Subject: Re: fanotify: the fscking all notification system
In-Reply-To: <1246306125.754.300.camel@dhcp235-23.rdu.redhat.com>
Message-ID: <alpine.LSU.2.00.0907021654360.26791@fbirervta.pbzchgretzou.qr>
References: <1246306125.754.300.camel@dhcp235-23.rdu.redhat.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2009-06-29 22:08, Eric Paris wrote:
>
>struct fanotify_event_metadata {
>        __u32 event_len;
>        __s32 fd;
>        __u32 mask;
>        __u32 f_flags;
>        pid_t pid;
>        pid_t tgid;
>        __u64 cookie;
>}  __attribute__((packed));

Why pid_t and not s32 like the other fields are?

>3) call getsockattr on the socket to get back data about events that
>took place and to get fd's opened in your context
>[..].
>This provides information about the event including the type, the
>location of the new fd that was opened pointing to the object in
>question, and it provides information about the process which triggered
>the event.

Now the question would be whether getsockattr (meant getsockopt?)
returns data about one event or multiple events.

Why is not read() used? Sure, it is not as easy, but if you require
the size argument to read() being at least sizeof(event_metadata),
things should fit, should not they?
Using getsockopt feels like an ioctl - and they for one are
more or less discouraged in light of netlink for example.

>fanotify has two basic 'modes' directed and global.  fanotify directed
>works much like inotify in that userspace marks inodes it is interested
>in and gets events from those inodes.  fanotify global instead indicates
>that it wants everything on the system and then individually marks
>inodes that it doesn't care about.

So indexers and such only need a single fd for getting notifications
about touched files? Sounds great.
