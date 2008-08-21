Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414AbYHUFog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbYHUFog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 01:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYHUFoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 01:44:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:25301 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbYHUFoY (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 01:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=c04uUvbgEbybhrqz2T3QyTxf1eDWJS8gM+UTQpzF4ygz54aiInZkhK8nO58JzR/8q5
         d0pJvJY1aNH8YrFxlemIECxsyImkBYFeconC4p7mI8ED3eshMsjpytkVZ6A1zO+S4qTg
         neojqk4kEGfZ07h5B+POO8eQ6raXqqEqB3jk0=
Message-ID: <48AD00C4.6060302@gmail.com>
Date: Wed, 20 Aug 2008 22:44:36 -0700
From: Jared Hulbert <jaredeh@gmail.com>
Reply-To: jaredeh@gmail.com
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: [PATCH 00/10] AXFS: Advanced XIP filesystem
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to get a first round of review on my AXFS filesystem.  This is a simple
read only compressed filesystem like Squashfs and cramfs.  AXFS is special
because it also allows for execute-in-place of your applications.  It is a major
improvement over the cramfs XIP patches that have been floating around for ages.
The biggest improvement is in the way AXFS allows for each page to be XIP or
not.  First, a user collects information about which pages are accessed on a
compressed image for each mmap()ed region from /proc/axfs/volume0.  That
'profile' is used as an input to the image builder.  The resulting image has
only the relevant pages uncompressed and XIP.  The result is smaller memory
sizes and faster launches.
                            

See http://axfs.sourceforge.net for more info.


fs/Kconfig                |   21 +
fs/Makefile               |    1 
fs/axfs/Makefile          |    7 
fs/axfs/axfs_bdev.c       |  158 ++++++++
fs/axfs/axfs_inode.c      |  490 ++++++++++++++++++++++++++
fs/axfs/axfs_mtd.c        |  233 ++++++++++++
fs/axfs/axfs_profiling.c  |  594 +++++++++++++++++++++++++++++++
fs/axfs/axfs_super.c      |  866 ++++++++++++++++++++++++++++++++++++++++++++++
fs/axfs/axfs_uml.c        |   47 ++
fs/axfs/axfs_uncompress.c |   97 +++++
include/linux/axfs.h      |  358 +++++++++++++++++++
11 files changed, 2872 insertions(+)


