Return-Path: <linux-kernel-owner+w=401wt.eu-S933433AbXHPIUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433AbXHPIUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 04:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762589AbXHPIUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 04:20:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:58791 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbXHPIUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 04:20:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=uCXr1k+9eWg1IQ+nfFIG2NaE5mOqG93wJDjg70S0K/KWgG+T7jT1azs1h1j5f6s1lV0zwGB2O2p9ocbQQLGSWQ9UE1WU+Gu9tKCAUwicnxZXKySEQ0/n2jIWvatjfD0sCYtAaxVX2569iauvX8TYqZkpsCAX8Q00I5GeNyu1Z3Q=
Message-ID: <91b13c310708160120v7379d867k73ecf1995719d694@mail.gmail.com>
Date: Thu, 16 Aug 2007 16:20:11 +0800
From: "=?BIG5?B?tXul9KX+?=" <chengrq@uit.com.cn>
To: cluster-devel@redhat.com
Subject: [gfs2][RFC] readdir caused ls process into D (uninterruptible) state, under testing with Samba 3.0.25
Cc: "Steven Whitehouse" <swhiteho@redhat.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: de65bcbc5820ad36
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that gfs2 cannot work well with Samba,

I'm using the gfs2 and the new cluster suite(cman with openais),

1. the testing environment is that 1 iscsi target and 2 cluster node,
2. the two nodes both used iscsi initiator connect to the target,
3. they're using the same physical iscsi disk,
4. run LVM2 on top of the same iscsi disk,
5. on the same lv (logical volume), I created a gfs2 filesystem,
6. mount the gfs2 system to a same path under 2 nodes,
7. start samba to shared the gfs2 mounting pointer on the 2 nodes,

now test with windows client, when two or above clients connects to the samba,
everything is still normal; but when heavy writers or readers start,
the samba server daemon changed to D state, that's uninterruptible in
the kernel,
I wonder that's a problem of gfs2?

then I start a simple ls command on the gfs2 mouting point:
$ ls /mnt/gfs2
the ls process is also changed to D state,

I think it's problems about readdir implementation in gfs2, and I want
to fix it, someone could give me some pointers?

-- 
Denis Cheng
