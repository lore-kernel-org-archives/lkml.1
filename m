Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZCYWeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZCYWeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 18:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbZCYWdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 18:33:55 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:33622 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbZCYWdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 18:33:54 -0400
Subject: Re: NFS/AFS/Selinux issues with 2.26.29
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Richard A Nelson <cowboy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       openafs-devel@openafs.org
In-Reply-To: <49CAAB9B.5070104@linux.vnet.ibm.com>
References: <49CAAB9B.5070104@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 18:33:44 -0400
Message-Id: <1238020424.26487.81.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 9AE50DA7206CB54CA09AF12F479C149AC94845A7
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 112 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 15:09 -0700, Richard A Nelson wrote:
> 1) 2.6.29 NFS clients can no longer lock files:
>    #strace -f lockfile fubar
>    ...
>    uname({sys="Linux", node="gothic-ave", ...}) = 0
>    lstat64("_V0H.jaqyJB.gothic-ave", 0xbfdac9ec) = -1 ENOENT (No such file or directory)
>    open("_V0H.jaqyJB.gothic-ave", O_WRONLY|O_CREAT|O_EXCL|O_LARGEFILE, 0444) = -1 EINVAL (Invalid argument)
>    write(2, "lockfile: ", 10lockfile: )              = 10
>    write(2, "Try praying", 11Try praying)             = 11
>    write(2, ", giving up on \"", 16, giving up on ")       = 16
>    write(2, "fubar", 5fubar)                    = 5
>    write(2, "\"\n", 2"
> 
>    clients still on 2.6.28 and lower work fine ... the server *is* 2.26.29

lockfile works fine for me, both on NFSv3 and NFSv4 against my NetApp
filers, and as far as I can remember, there have been no changes to the
exclusive create code in the 2.6.29 client.

Given that you are claiming to be seeing selinux problems on
2.6.29-based servers, could you therefore please check again after
downgrading the server kernel?

Trond

