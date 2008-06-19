Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbYFSR35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbYFSR35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 13:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYFSR3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 13:29:50 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:38851 "EHLO
	ns1.utah-nac.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750834AbYFSR3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 13:29:49 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2008 13:29:49 EDT
Message-ID: <1548.69.2.248.210.1213895504.squirrel@webmail.wolfmountaingroup.com>
Date: Thu, 19 Jun 2008 11:11:44 -0600 (MDT)
Subject: Question about sys_ind (Partition ID fields)
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Is there a reason why the sys_ind field (The partition ID) s not cached in
the hd_struct persistently?  I noticed that after the initial
check_partition calls through check_part[]() read all this data and only
remember the starting sector and size of a given partition.  Perhaps I am
missing something, and its stored somewhere else, but I have not located
it yet.

This seems somwhat wasteful since it requires the partition tables and/or
partitions to be re-read all the time instead of just remembering what
sys_ind was previously set.   The argument that it is this way for
supporting dynamic rescanning doesn't seem to match up to the way its
implemented since you have to rescan anyway in most cases.  It makes it
somewhat ackward whem you are instrumenting multi-partition storage
modules.

Jeff

