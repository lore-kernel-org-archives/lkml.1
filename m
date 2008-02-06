Return-Path: <linux-kernel-owner+w=401wt.eu-S1762146AbYBFBtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762146AbYBFBtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 20:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756934AbYBFBto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 20:49:44 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:31677 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbYBFBtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 20:49:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=nqcIxoHJjDirJfO5V1fFxOByW6JDedsumRhQ1Lom7dFtBhvPgv5Gf4dtpkKFip7eGu15qHmqmp2WzbvH+oL+zhB0TeHte7Y7IYhZI+Cb8z4CUP4lrTDb9ZPNVjfYRGnc8d4b0ixqRrG52Iy6yjocoLaFAkOCTfqFQgMOYllE7j4=
Message-ID: <ecb4efd10802051749n6a626e84k3ac8210aa2b5a446@mail.gmail.com>
Date: Tue, 5 Feb 2008 20:49:42 -0500
From: "Clem Taylor" <clem.taylor@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: inotify_add_watch() returning ENOSPC in 2.6.24 [watch descriptor leak?]
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to move a MIPS based embedded system from 2.6.16.16 to
2.6.24. Most things seem to be working, but I'm having troubles with
inotify. The code is using inotify to detect a file written to /tmp
(tmpfs). The writer creates a file with a temporary name and then
rename()s the tmp file over the file I'm monitoring.

With 2.6.16.16, everything works fine, but with 2.6.24, the inotify
process runs for a while (~100 events) and then inotify_add_watch()
returns ENOSPC. Once this happens, I can't add new watches, even if I
kill the process and restart it. fs.inotify.max_user_instances and
fs.inotify.max_user_watches are both 128, so I'd imagine I'm hitting
this limit. For some reason the watches aren't getting cleaned up
(even after the process is killed).

In a loop, the code is doing:
    wd = inotify_add_watch(fd, file, IN_CLOSE_WRITE|IN_DELETE_SELF|IN_ONESHOT);
    blocking read on notify fd

Has something changed in the inotify() API since 2.6.16.16, or could
this be a leak?

                                      --Clem
