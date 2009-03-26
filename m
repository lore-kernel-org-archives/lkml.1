Return-Path: <linux-kernel-owner+w=401wt.eu-S1761345AbZCZTlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345AbZCZTlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 15:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932170AbZCZTlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 15:41:00 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:46154 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755572AbZCZTk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 15:40:59 -0400
Subject: Re: NFS/AFS/Selinux issues with 2.26.29
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Richard A Nelson <cowboy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       openafs-devel@openafs.org
In-Reply-To: <49CACF78.80305@linux.vnet.ibm.com>
References: <49CAAB9B.5070104@linux.vnet.ibm.com>
	 <1238020424.26487.81.camel@heimdal.trondhjem.org>
	 <49CACF78.80305@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 26 Mar 2009 15:40:52 -0400
Message-Id: <1238096452.13095.22.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: A21457DD790B2F032203DA6A89619ECE2D3F1F7C
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 3 total 120 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 17:42 -0700, Richard A Nelson wrote:
> Trond Myklebust wrote:
> > On Wed, 2009-03-25 at 15:09 -0700, Richard A Nelson wrote:
> >> 1) 2.6.29 NFS clients can no longer lock files:
> ...
> > 
> > Given that you are claiming to be seeing selinux problems on
> > 2.6.29-based servers, 
> 
> Yeah, I fixed the SeLinux issues by disabling it at boot
> 
> > could you therefore please check again after
> > downgrading the server kernel?
> 
> I dropped the server to:
> # uname -a
> Linux el-ghor 2.6.28.8 #19 SMP Sun Mar 22 18:41:28 UTC 2009 x86_64 GNU/Linux
> 
> And still see same lockfile error.
> 
> However, a typo showed that locking is indeed working fine - for everything
> except one directory tree (/root/Mail) ... re-mounting and even rebooting one
> of the failing clients didn't help.
> 
> mounts are nfs3,sec=sys,posix,... and the server filesystem is ext3 w/acls
> rpc.statd is active on all systems, and there is no firewall in the way
> 
> So now the server and one client have been rebooted, and the client can
> lock files anywhere but the directory tree for /root/Mail
> sm-notify -f (from the client) didn't help
> 
> Somewhere, there is persistant state that is keeping two out of three
> local systems from creating locks and it all started after upgrading the
> kernel ... colour me dazed and confused, but trying to continue ;)
> 
> /me goes in search of lock display tools (cat /proc/locks isn't yet enough for me)

Have you used wireshark to inspect what is going down the wire when this
exclusive create attempt fails? That would help in narrowing down
whether it is the client or the server that is being problematic.

Cheers
  Trond

