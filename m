Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbYIBWc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbYIBWc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 18:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYIBWcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 18:32:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:60637 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbYIBWcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 18:32:18 -0400
Subject: Re: [PATCH] UBIFS: fill f_fsid
From: David Woodhouse <dwmw2@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Dilger <adilger@sun.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
In-Reply-To: <20080902210219.GA9856@infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
	 <1220194366-12731-13-git-send-email-dedekind@infradead.org>
	 <1220262187.2982.58.camel@pmac.infradead.org>
	 <20080901150147.GA20323@infradead.org> <1220339032.4036.31.camel@sauron>
	 <20080902170954.GE3086@webber.adilger.int>
	 <20080902210219.GA9856@infradead.org>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 23:32:07 +0100
Message-Id: <1220394727.2985.28.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 17:02 -0400, Christoph Hellwig wrote:
> Umm, different things.  f_fsid in stat(v)fs is just a cookie exported to
> userspac that has never really been documented.

Our man page for statfs(2) says...

 The f_fsid field

   Solaris,  Irix  and  POSIX have a system call statvfs(2) that returns a
   struct statvfs (defined in <sys/statvfs.h>) containing an unsigned long
   f_fsid.   Linux,  SunOS, HP-UX, 4.4BSD have a system call statfs() that
   returns a struct statfs (defined in <sys/vfs.h>)  containing  a  fsid_t
   f_fsid,  where  fsid_t  is defined as struct { int val[2]; }.  The same
   holds for FreeBSD, except that it uses the include file  <sys/mount.h>.

   The  general  idea  is that f_fsid contains some random stuff such that
   the pair (f_fsid,ino) uniquely determines a file.   Some  OSes  use  (a
   variation on) the device number, or the device number combined with the
   filesystem type.  Several OSes restrict giving out the f_fsid field  to
   the  superuser  only (and zero it for unprivileged users), because this
   field is used in the filehandle of the  filesystem  when  NFS-exported,
   and giving it out is a security concern.

   Under some OSes the fsid can be used as second parameter to the sysfs()
   system call.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



