Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbYJBGx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbYJBGx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 02:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYJBGxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 02:53:51 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:45275 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbYJBGxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 02:53:51 -0400
Message-ID: <44010.166.70.238.43.1222928236.squirrel@webmail.wolfmountaingroup.com>
Date: Thu, 2 Oct 2008 00:17:16 -0600 (MDT)
Subject: do_filp_open fails to detect dentry revalidate of 1 and crashes
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


On assignment of a negative dentry, do_filp_open will crash with an oops
in do_sys_open because do_filp_open returns "1" from revalidate rather
than properly detect a negative dentry which has a dentry revalidate
function before the file actually exists.


Easy to reproduce.  Create negative dentry and attach a revalidate
function which returns 1 instead of 0 on non-existent file entry.   The
convoluted code in do_filp_open does not detect dentry errors in all cases
properly.

Jeff

