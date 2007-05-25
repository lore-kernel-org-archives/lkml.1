Return-Path: <linux-kernel-owner+w=401wt.eu-S1764386AbXEYUKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764386AbXEYUKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 16:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbXEYUKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 16:10:36 -0400
Received: from 20119106189.user.veloxzone.com.br ([201.19.106.189]:59227 "EHLO
	izvekov.dyndns.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbXEYUKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 16:10:35 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2007 16:10:34 EDT
Date: Fri, 25 May 2007 17:04:13 -0300
From: Matheus Izvekov <mizvekov@izvekov.dyndns.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [2.6.21] BUG: at fs/inotify.c:172 set_dentry_child_flags()
Message-ID: <20070525200413.GA29664@izvekov.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Got this BUG_ON twice in a row, just found it by scrolling thru my
dmesg.

BUG: at fs/inotify.c:172 set_dentry_child_flags()
[<c01936fc>] set_dentry_child_flags+0x10c/0x1a0
[<c01937e3>] remove_watch_no_event+0x53/0x60
[<c0193b30>] inotify_destroy+0x50/0xb0
[<c01941a4>] inotify_release+0x14/0x60
[<c016a4d3>] __fput+0x93/0x190
[<c01678c7>] filp_close+0x47/0x80
[<c0120b12>] put_files_struct+0x92/0xb0
[<c0121ddc>] do_exit+0x12c/0x870
[<c01168e1>] do_page_fault+0x321/0x610
[<c0122544>] do_group_exit+0x24/0x80
[<c0103f72>] sysenter_past_esp+0x5f/0x85
=======================

this was probably triggered by this small shell script i have:

while true;
do
	ls -1 \$MAIL/new/ | wc -l;
	inotifywait -e CREATE -e DELETE -e MOVE \$MAIL/new/ > /dev/null 2>/dev/null || break;
done

$MAIL is mounted from a reiserfs filesystem.
