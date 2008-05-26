Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbYEZKvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbYEZKvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 06:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbYEZKu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 06:50:59 -0400
Received: from burp.tkv.asdf.org ([212.16.99.49]:45336 "EHLO burp.tkv.asdf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbYEZKu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 06:50:58 -0400
X-Greylist: delayed 876 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 May 2008 06:50:58 EDT
To: linux-kernel@vger.kernel.org
Subject: Bug/misfeature of "securityfs"
From: Markku Savela <msa@moth.iki.fi>
Date: Mon, 26 May 2008 13:36:19 +0300
Message-ID: <87iqx1pd24.fsf@burp.tkv.asdf.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I write a module which creates a securityfs on init

  foobar =  securityfs_create_dir("foobar", NULL)
and on exit it does
  security_fs_remove(foobar);

When I do "insmod" and "rmmod", I see

  /sys/kernel/security/foobar/

appear and go away.

Now, if have a shell and do "cd /sys/kernel/security/foobar", the
"rmmod" does not remove the directory. The directory disappears when I
exit the shell from it via "cd ..". This is fine, and as it should be,
but....

IF, while having the shell in the directory, I try to "insmod" again,
the insmod fails with "-1 File exists". Again, understandable, BUT
when after this I exit the shell from the directory, IT DOES NOT GO
AWAY. It's permanetly existing, and module install fails always with
"File Exists".

Is this a bug, or am doing something wrong?

The kernel is Ubuntu Hardy heron
    2.6.24-16-generic #1 SMP Thu Apr 10 13:23:42 UTC 2008 i686

-- 
Markku Savela
