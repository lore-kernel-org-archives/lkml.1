Return-Path: <linux-kernel-owner+w=401wt.eu-S1751486AbXBJR7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbXBJR7b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 12:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbXBJR7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 12:59:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:57321 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751486AbXBJR7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 12:59:30 -0500
X-Provags-ID: V01U2FsdGVkX18SKz5WKhMStwQc+lwLgqooqh3BMXwA8RnZSDsy3Y
	WGlg==
Message-ID: <45CE0737.6010103@gmx.net>
Date: Sat, 10 Feb 2007 09:56:07 -0800
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: val_henson@linux.interl.com
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Documenting MS_RELATIME
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Val,

I'm just updating the mount(2) man page for MS_RELATIME, and this is the
text I've come up with:

       MS_RELATIME(Since Linux 2.6.20)
              When a file on this file system is accessed, only
              update  the  file's last accessed time (atime) if
              the current value of atime is less than or  equal
              to  the file's last modified (mtime) or last sta-
              tus change time (ctime).  This option  is  useful
              for  programs, such as mutt(1), that need to know
              when a file has been read since it was last modi-
              fied.

This text is based on your comments accompanying the various patches, but
it differs in a respect.  Your comments said that the atime would only be
updated if the atime is older than mtime/ctime.  However, what the code
actually does is update atime if it is is <= mtime/ctime -- i.e., atime is
older than or *or equal to* mtime/ctime.

I'm sure that the code implements your intention, but before incorporating
the above text I thought I just better check, since the code differs from
your comment.  Can you just confirm that the proposed man page text is okay.

Cheers,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.
