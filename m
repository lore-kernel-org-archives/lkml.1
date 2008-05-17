Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYEQR5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYEQR5t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 13:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYEQR5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 13:57:38 -0400
Received: from mail.mindmedia.com.sg ([210.193.7.34]:49143 "EHLO
	mail.mindmedia.com.sg" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752752AbYEQR5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 13:57:37 -0400
Message-ID: <20080518015733.o7n8cvhomvgos8ow@mail.mindmedia.com.sg>
X-Priority: 3 (Normal)
Date: Sun, 18 May 2008 01:57:33 +0800
From: "P.V.Anthony" <pvantony@singnet.com.sg>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Solved - How to change the FSINFO for nfsd?
References: <482332CD.4010706@singnet.com.sg>
	<20080509042238.GC21408@fieldses.org>
In-Reply-To: <20080509042238.GC21408@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting "J. Bruce Fields":
> I think you'reprobably barking up the wrong tree, but the max file size
> as returned by fsinfo is set in fs/nfsd/nfs3proc.c:nfsd3_proc_fsinfo().

Just in case someone needs to know this information. Please note that  
I am not a
programmer. I am just hacking away.

Most of the credit for the hack goes to the person in the forum  
mentioned below
for finding the Mac NFS behavior.
http://forums.creativecow.net/thread/8/975362

The changes done seem to work well.

I am dissapointed that Apple made changes to NFS to a point that we  
have to use an Apple NFS. I thought that NFS is open. Anyway with  
these changes, a Linux server can be used.

Anyway this problem only happens from with in the video editing application,
Final Cut Pro, an Apple product. I hope someday a good video editing  
application
comes to Linux. I am willing to pay for Linux video editing  
application. It must
be good that is.

Anyway here is the patch done.

------------------- start ------------------------------

pv at videoserver2 ~ $ diff -ruN
/usr/src/linux-2.6.22-gentoo-r8/fs/nfsd/nfs3proc.c.org
/usr/src/linux-2.6.22-gentoo-r8/fs/nfsd/nfs3proc.c
--- /usr/src/linux-2.6.22-gentoo-r8/fs/nfsd/nfs3proc.c.org 2008-05-09
13:07:19.000000000 +0800
+++ /usr/src/linux-2.6.22-gentoo-r8/fs/nfsd/nfs3proc.c 2008-05-13
23:54:56.000000000 +0800
@@ -555,7 +555,7 @@
resp->f_wtpref = max_blocksize;
resp->f_wtmult = PAGE_SIZE;
resp->f_dtpref = PAGE_SIZE;
- resp->f_maxfilesize = ~(u32) 0;
+ resp->f_maxfilesize = 0xffffffffffffffff;
resp->f_properties = NFS3_FSF_DEFAULT;

nfserr = fh_verify(rqstp, &argp->fh, 0, MAY_NOP);
@@ -570,7 +570,7 @@
if (sb->s_magic == 0x4d44 /* MSDOS_SUPER_MAGIC */) {
resp->f_properties = NFS3_FSF_BILLYBOY;
}
- resp->f_maxfilesize = sb->s_maxbytes;
+ resp->f_maxfilesize = 0xffffffffffffffff;
}

fh_put(&argp->fh);

---------------- end -------------------------------------------------

P.V.Anthony


