Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZIBX2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZIBX2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 19:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbZIBX2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 19:28:09 -0400
Received: from fmailhost02.isp.att.net ([204.127.217.102]:57504 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbZIBX2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 19:28:08 -0400
X-Originating-IP: [76.109.153.227]
Date: Wed, 2 Sep 2009 19:28:09 -0400
From: Tom Horsley <tom.horsley@att.net>
To: linux-kernel@vger.kernel.org
Subject: ptrace & /proc deadlock due to mm_for_maps cred_guard_mutex patch
Message-ID: <20090902192809.5f3efb48@zooty>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The redhat bugzilla:

https://bugzilla.redhat.com/show_bug.cgi?id=520206#c2

describes a test program that demonstrates an apparent
deadlock ptrace can get into as a result of the
patch:

   commit 704b836cbf19e885f8366bccb2e4b0474346c02d
   Author: Oleg Nesterov <oleg@redhat.com>
   Date:   Fri Jul 10 03:27:40 2009 +0200
   mm_for_maps: take ->cred_guard_mutex to fix the race with exec  

ptrace hangs attempting to read the newly exec'ed debugged
child process /proc/pid/maps file, and the child is obviously
never going to advance as long as it is stopped by ptrace.

I haven't seen any activity on the bugzilla, so since this
was a kernel.org patch I figured I'd mention it over here.

As the bugzilla says, it is possible to work around this by
single stepping the debugged process before reading the maps
file.
