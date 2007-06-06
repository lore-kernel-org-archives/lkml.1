Return-Path: <linux-kernel-owner+w=401wt.eu-S1765392AbXFFM14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765392AbXFFM14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 08:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761957AbXFFM1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 08:27:48 -0400
Received: from pat.uio.no ([129.240.10.15]:57973 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759852AbXFFM1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 08:27:47 -0400
Subject: Re: 2.6.21.3: NFS: Buggy server - nlink == 0!
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070606081303.GB7168@localdomain>
References: <20070606081303.GB7168@localdomain>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 08:27:42 -0400
Message-Id: <1181132862.6171.2.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.092,UPPERCASE_25_50=0)
X-UiO-Scanned: 8BCE2AA9976B40EB2EB43BEB9ED302C5984AC0BA
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1238 total 2211731 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The server is returning a deleted file to the client as the result of a
lookup() call. I'd call that a server bug.

Trond


On Wed, 2007-06-06 at 01:13 -0700, Ravikiran G Thirumalai wrote:
> While running a dbench stress test on  a nfs mounted file system, I notice
> the subject error message on the client machine.  The client machine is a 48
> core box with NUMA characteristics and 1024 dbench processes running
> continuously in a loop, while another memory hog application runs in parallel.
> The client is on 2.6.21.3.  The server is booted up with 2.6.21.3 as well.
> Attached is the server configuration.  Same test on a 2.6.16 client does not
> spew out these messages.  Is this really the server issue, or is the NFS
> client to be blamed here?
> 
> fstab on the client goes as:
> vus2:/mnt/sda5          /nfstest                nfs  udp,wsize=32768,rsize=32768 0 0
> 
> /etc/exports on the server looks like:
> /mnt/sda5 *(rw,no_root_squash,sync)
> 
> I will be happy to post full config/dmesg if required.
> 
> The client side NFS config goes as:
> #
> # Network File Systems
> #
> CONFIG_NFS_FS=y
> CONFIG_NFS_V3=y
> # CONFIG_NFS_V3_ACL is not set
> # CONFIG_NFS_V4 is not set
> CONFIG_NFS_DIRECTIO=y
> CONFIG_NFSD=y
> CONFIG_NFSD_V3=y
> # CONFIG_NFSD_V3_ACL is not set
> # CONFIG_NFSD_V4 is not set
> CONFIG_NFSD_TCP=y
> CONFIG_LOCKD=y
> CONFIG_LOCKD_V4=y
> CONFIG_EXPORTFS=y
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=y
> # CONFIG_RPCSEC_GSS_KRB5 is not set
> # CONFIG_RPCSEC_GSS_SPKM3 is not set
> 
> The server side NFS config goes as:
> 
> #
> # Network File Systems
> #
> CONFIG_NFS_FS=m
> CONFIG_NFS_V3=y
> CONFIG_NFS_V3_ACL=y
> # CONFIG_NFS_V4 is not set
> CONFIG_NFS_DIRECTIO=y
> CONFIG_NFSD=m
> CONFIG_NFSD_V2_ACL=y
> CONFIG_NFSD_V3=y
> CONFIG_NFSD_V3_ACL=y
> CONFIG_NFSD_V4=y
> CONFIG_NFSD_TCP=y
> CONFIG_LOCKD=m
> CONFIG_LOCKD_V4=y
> CONFIG_EXPORTFS=m
> CONFIG_NFS_ACL_SUPPORT=m
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=m
> 
> Thanks,
> Kiran
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

