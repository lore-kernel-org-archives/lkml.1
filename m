Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbZCZAmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbZCZAmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 20:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbZCZAmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 20:42:42 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56898 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbZCZAml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 20:42:41 -0400
Message-ID: <49CACF78.80305@linux.vnet.ibm.com>
Date: Wed, 25 Mar 2009 17:42:32 -0700
From: Richard A Nelson <cowboy@linux.vnet.ibm.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       openafs-devel@openafs.org
Subject: Re: NFS/AFS/Selinux issues with 2.26.29
References: <49CAAB9B.5070104@linux.vnet.ibm.com> <1238020424.26487.81.camel@heimdal.trondhjem.org>
In-Reply-To: <1238020424.26487.81.camel@heimdal.trondhjem.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> On Wed, 2009-03-25 at 15:09 -0700, Richard A Nelson wrote:
>> 1) 2.6.29 NFS clients can no longer lock files:
...
> 
> Given that you are claiming to be seeing selinux problems on
> 2.6.29-based servers, 

Yeah, I fixed the SeLinux issues by disabling it at boot

> could you therefore please check again after
> downgrading the server kernel?

I dropped the server to:
# uname -a
Linux el-ghor 2.6.28.8 #19 SMP Sun Mar 22 18:41:28 UTC 2009 x86_64 GNU/Linux

And still see same lockfile error.

However, a typo showed that locking is indeed working fine - for everything
except one directory tree (/root/Mail) ... re-mounting and even rebooting one
of the failing clients didn't help.

mounts are nfs3,sec=sys,posix,... and the server filesystem is ext3 w/acls
rpc.statd is active on all systems, and there is no firewall in the way

So now the server and one client have been rebooted, and the client can
lock files anywhere but the directory tree for /root/Mail
sm-notify -f (from the client) didn't help

Somewhere, there is persistant state that is keeping two out of three
local systems from creating locks and it all started after upgrading the
kernel ... colour me dazed and confused, but trying to continue ;)

/me goes in search of lock display tools (cat /proc/locks isn't yet enough for me)
-- 
Rick
