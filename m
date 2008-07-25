Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbYGYHHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbYGYHHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 03:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYGYHHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 03:07:45 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:40066 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477AbYGYHHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 03:07:44 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25.12, 2.6.26-git11: Is this odd NFS behaviour?
Date: Fri, 25 Jul 2008 17:07:25 +1000
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <40ui84lotn5qihetlgeu2km5vu6jtrd971@4ax.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

G'day,

I'm editing a script on a box running 2.6.25.12 and exported on NFS, 
I'm testing the script on another two boxes, one running 2.6.25.12 
and the other 2.6.26-git11.

Sometimes I save the edit file and the test boxes don't see the file 
change, so I have to save the file again.  I'm using vim 7.0 if it 
matters.

All boxes are connected to localnet and I'm working through PuTTY 
terminals on a WinXP desktop box.  (Three linux boxes headless).

There were times when I saved and quit the edit file, had to reopen 
it and save-quit again for the test boxes to see the changes.

nfs exports:
grant@deltree:~$ cat /etc/exports
# See exports(5) for a description.
# This file contains a list of all directories exported to other computers.
# It is used by rpc.nfsd and rpc.mountd.

/home/common            192.168.1.0/24(sync,rw,no_root_squash,subtree_check)
/home/mirror            192.168.1.0/24(sync,ro,no_root_squash,subtree_check)
#

test box:
grant@black:~$ cat /etc/fstab
...
deltree:/home/common    /home/common    nfs     hard,intr
deltree:/home/mirror    /home/mirror    nfs     hard,intr

File is on the /home/common nfs rw export.
Is this something I'm doing wrong or something odd with the kernel?

config + dmesg from:
  http://bugsplatter.mine.nu/test/boxen/black/
  http://bugsplatter.mine.nu/test/boxen/deltree/

And where did the nfsd TCP option go in -git11?  Does it matter?

Thanks,
Grant.
