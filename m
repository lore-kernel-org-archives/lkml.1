Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbYBZXmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYBZXmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755662AbYBZXmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:42:16 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:38145 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbYBZXmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:42:15 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH -mm 2/4] SELinux: Remove various exported symbols
Date: Tue, 26 Feb 2008 18:42:12 -0500
User-Agent: KMail/1.9.7
Cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-security-module@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
References: <20080226232229.GA12059@ubuntu> <20080226232541.GC12059@ubuntu>
In-Reply-To: <20080226232541.GC12059@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802261842.12459.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008 6:25:41 pm Ahmed S. Darwish wrote:
> Remove the following exported SELinux interfaces:
> selinux_get_inode_sid(inode, sid)
> selinux_get_ipc_sid(ipcp, sid)
> selinux_get_task_sid(tsk, sid)
> selinux_sid_to_string(sid, ctx, len)
>
> and substitue them with following equivalents respectively:
> new LSM hook, inode_getsecid(inode, secid)
> new LSM hook, ipc_getsecid*(ipcp, secid)
> LSM hook, task_getsecid(tsk, secid)
> LSM hook, sid_to_secctx(sid, ctx, len)
>
> This is done to remove SELinux dependency from some
> of the kernel subsystems (audit).
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> ---
>
>  include/linux/selinux.h    |   62
> ---------------------------------------------
> security/selinux/exports.c |   42 ------------------------------
> security/selinux/hooks.c   |   19 ++++++++++++-
>  3 files changed, 17 insertions(+), 106 deletions(-)

I haven't had a chance to look at the rest of the changes in detail yet, 
but this should be the last patch in the series.  The reason is that 
after applying this patch (and not the next two) the kernel will no 
longer compile meaning bisects will break which will cause people to 
get grumpy.

If you have to split things into multiple patches, it's a good idea to 
do it in this order:

 1. Add the new function
 2. Convert all the callers
 3. Remove the old function you replaced

-- 
paul moore
linux security @ hp
