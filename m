Return-Path: <linux-kernel-owner+w=401wt.eu-S1759422AbXFFINZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbXFFINZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 04:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbXFFINK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 04:13:10 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:55718 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbXFFINI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 04:13:08 -0400
Date: Wed, 6 Jun 2007 01:13:03 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: nfs@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.21.3: NFS: Buggy server - nlink == 0!
Message-ID: <20070606081303.GB7168@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While running a dbench stress test on  a nfs mounted file system, I notice
the subject error message on the client machine.  The client machine is a 48
core box with NUMA characteristics and 1024 dbench processes running
continuously in a loop, while another memory hog application runs in parallel.
The client is on 2.6.21.3.  The server is booted up with 2.6.21.3 as well.
Attached is the server configuration.  Same test on a 2.6.16 client does not
spew out these messages.  Is this really the server issue, or is the NFS
client to be blamed here?

fstab on the client goes as:
vus2:/mnt/sda5          /nfstest                nfs  udp,wsize=32768,rsize=32768 0 0

/etc/exports on the server looks like:
/mnt/sda5 *(rw,no_root_squash,sync)

I will be happy to post full config/dmesg if required.

The client side NFS config goes as:
#
# Network File Systems
#
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
# CONFIG_NFS_V4 is not set
CONFIG_NFS_DIRECTIO=y
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
# CONFIG_NFSD_V4 is not set
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
# CONFIG_RPCSEC_GSS_KRB5 is not set
# CONFIG_RPCSEC_GSS_SPKM3 is not set

The server side NFS config goes as:

#
# Network File Systems
#
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
# CONFIG_NFS_V4 is not set
CONFIG_NFS_DIRECTIO=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m

Thanks,
Kiran
