Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbYGXAW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbYGXAW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 20:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYGXAWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 20:22:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:5325 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbYGXAWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 20:22:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ufHAKlsMIHb5vL52CY3ZhYO8rBy2x/FuOSpyno907I7dzaOf5TVXAduCoWycqQPvqI
         LWc/cJp+AE0YlvkWmlWfnpnqOx+bEo6E1cGe/9B/AtuGE+2Jv815ECHf1ZJCMW16dEvd
         ivBz1oapR3S8FK3d5pSYoRVAtMATLkU0YlB4s=
Message-ID: <524f69650807231722q74269919s4fcf95d51d438ff4@mail.gmail.com>
Date: Wed, 23 Jul 2008 19:22:47 -0500
From: "Steve French" <smfrench@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: new sparse warnings
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any idea what the new sparse "context imbalance" warnings are?  Is
this a bug in sparse?

stevef@smf-t60p:~/kernels/cifs-2.6-devel> make modules C=1
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHECK   fs/cifs/cifssmb.c
fs/cifs/cifssmb.c:134:2: warning: context imbalance in
'mark_open_files_invalid': wrong count at exit
fs/cifs/cifssmb.c:134:2:    context 'lock': wanted 0, got 1
fs/cifs/cifssmb.c:5191:9: warning: context imbalance in
'CIFSSMBNotify': wrong count at exit
fs/cifs/cifssmb.c:5191:9:    context 'lock': wanted 0, got 1
  CC [M]  fs/cifs/cifssmb.o

The functions it is complaining about don't seem to have a "context
imbalance" see e.g.the one near line 134 of fs/cifs/cifssmb.c

static void mark_open_files_invalid(struct cifsTconInfo *pTcon)
{
        struct cifsFileInfo *open_file = NULL;
        struct list_head *tmp;
        struct list_head *tmp1;

/* list all files open on tree connection and mark them invalid */
        write_lock(&GlobalSMBSeslock);
        list_for_each_safe(tmp, tmp1, &pTcon->openFileList) {
                open_file = list_entry(tmp, struct cifsFileInfo, tlist);
                if (open_file)
                        open_file->invalidHandle = true;
        }
        write_unlock(&GlobalSMBSeslock);
}


-- 
Thanks,

Steve
