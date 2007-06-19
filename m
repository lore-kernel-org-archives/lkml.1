Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbXFSIKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbXFSIKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 04:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbXFSIKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 04:10:17 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:38892 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbXFSIKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 04:10:15 -0400
Message-ID: <46778F60.5090107@dgreaves.com>
Date: Tue, 19 Jun 2007 09:10:08 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       David Chinner <dgc@sgi.com>
Subject: xfs freeze/umount problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
 > FWIW, I'm on record stating that "sync" is not sufficient to quiesce an XFS
 > filesystem for a suspend/resume to work safely and have argued that the only
 > safe thing to do is freeze the filesystem before suspend and thaw it after
 > resume.

Whilst testing a potential bug in another thread I accidentally found that 
unmounting a filesystem that I'd just frozen would hang.

As the saying goes: "Well, duh!!"

I could eventually run an unfreeze but the mount was still hung. This lead to an 
unclean shutdown.

OK, it may not be bright but it seems like this shouldn't happen; umount should 
either unfreeze and work or fail ("Attempt to umount a frozen filesystem.") if 
the fs is frozen.

Is this a kernel bug/misfeature or a (u)mount one?
Suggestions as to the best place to report it if not in the cc's?

David
