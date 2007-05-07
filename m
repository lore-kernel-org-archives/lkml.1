Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXEGLWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXEGLWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 07:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933041AbXEGLWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 07:22:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:60355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012AbXEGLWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 07:22:14 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Ext3 vs NTFS performance
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       Christoph Hellwig <hch@infradead.org>,
       Anton Altaparmakov <aia21@cam.ac.uk>,
       Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Mon, 07 May 2007 13:21:28 +0200
References: <8gShI-3hY-11@gated-at.bofh.it> <8h1bh-8sG-11@gated-at.bofh.it> <8h2Al-280-1@gated-at.bofh.it> <8hW9y-2Lp-3@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1Hl1HU-0000h1-8I@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+RS8IeUkD8Mj1mTELfXqmqfcjexZz2vzHLK6U
 PAhVgb6QQkEuyiujoJaJOMgHoBIvHSXKj+madCa2swlx/q/8wi
 i4I1Pe2ki2PY/Jt/75p6Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel <joern@lazybastard.org> wrote:
> On Fri, 4 May 2007 10:46:10 +0100, Christoph Hellwig wrote:

>> Which means the right place to fix this is samba.  Samba just need
>> to intersept lseek and pread/pwrite to never allocate sparse files
>> but do the right thing instead.  Now what the right thing would probably
>> be a preallocate instead of writing zeroes, and we need to provide the
>> infrastructure for them to do it, which is in progress currently.
> 
> Why do preallocate and not just truncate the file?

If it's done by samba, it's racy. Only the kernel can reliably tell a
write-beyond-eof from a write-before-eof. Either it should unconditionally
turn these preallocation-writes into truncates, or have a flag which will
turn this feature on and which can be used to turn the lseek into a real
preallocation call.

I don't think unconditionally turning these writes into truncate would be
good, it would change the behaviour of dd bs=1 count=$(($n*$BLOCKSIZE+1)).
-- 
Top 100 things you don't want the sysadmin to say:
17. dd if=/dev/null of=/vmunix

Friß, Spammer: Gy9b.pfols@qy4ia.7eggert.dyndns.org rlk@r.7eggert.dyndns.org
