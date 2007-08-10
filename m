Return-Path: <linux-kernel-owner+w=401wt.eu-S965084AbXHJUWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965084AbXHJUWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964985AbXHJUVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:21:44 -0400
Received: from relay1.vsu.ru ([62.76.169.14]:49760 "EHLO relay1.vsu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932333AbXHJUVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:21:42 -0400
X-Greylist: delayed 3605 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Aug 2007 16:21:32 EDT
From: Vladimir Volovich <vvv@vsu.ru>
To: linux-kernel@vger.kernel.org
Subject: nfs - duplicate directory entries
Date: Fri, 10 Aug 2007 23:21:15 +0400
Message-ID: <87fy2rgpqs.fsf@vvv.vsu.ru>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

we have an NFS server (windows-based), and mount a directory from this
server on a linux box; there is some bug appearing sometimes, namely
some of the directory entries are reported twice:

$ ls | wc
   5968    5968   41776
$ ls | uniq | wc
   5964    5964   41748
$ ls | uniq -d
112920
112921
112922
112923
$ ls -li | grep '11292[0123]'
8507232 drwx------ 2 web web 64 2007-02-09 10:54 112920
8507232 drwx------ 2 web web 64 2007-02-09 10:54 112920
8507219 drwx------ 2 web web 64 2007-02-09 10:54 112921
8507219 drwx------ 2 web web 64 2007-02-09 10:54 112921
8507195 drwx------ 2 web web 64 2007-02-09 10:54 112922
8507195 drwx------ 2 web web 64 2007-02-09 10:54 112922
8507188 drwx------ 2 web web 64 2007-02-09 10:54 112923
8507188 drwx------ 2 web web 64 2007-02-09 10:54 112923

i.e. the current directory contains sub-directory 112920 twice,
sub-directory 112921 twice, etc. - and the inode numbers are the same.

i wonder if you have ever seen such strange behavior?  sometimes this
behavior is cured by unmounting and remounting the directory; but it
occurs regularly and reliably.

this does not happen if the directory from the same NFS server is
mounted on FreeBSD box.

linux version is 2.6.22 (from debian "sid").

the following information may of may not be related to the above bug:
the nfs server always reports link count for any directory as 2,
regardless of the number of subdirectories. (so e.g. find(1) says one
should use the -noleaf option).

if you need me to provide more information, please let me know.

Best,
v.
