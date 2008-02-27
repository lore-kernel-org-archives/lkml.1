Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbYB0QFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbYB0QFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 11:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbYB0QFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 11:05:00 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:43294 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbYB0QE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 11:04:59 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH -mm 1/4] LSM: Introduce inode_getsecid and ipc_getsecid hooks
Date: Wed, 27 Feb 2008 11:04:57 -0500
User-Agent: KMail/1.9.7
Cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-security-module@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
References: <20080226232229.GA12059@ubuntu> <20080226232411.GB12059@ubuntu>
In-Reply-To: <20080226232411.GB12059@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802271104.57815.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008 6:24:11 pm Ahmed S. Darwish wrote:
> Introduce inode_getsecid(inode, secid) and ipc_getsecid(ipcp, secid)
> LSM hooks.
>
> This hooks will be used instead of similar exported SELinux
> interfaces.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> ---
>
>  include/linux/security.h |   18 ++++++++++++++++++
>  security/dummy.c         |   12 ++++++++++++
>  security/security.c      |   12 ++++++++++++
>  3 files changed, 42 insertions(+)
>
> diff --git a/include/linux/security.h b/include/linux/security.h
> index a33fd03..a7fb136 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -449,6 +449,10 @@ struct request_sock;
>   *	@dentry is the dentry being changed.
>   *	Return 0 on success.  If error is returned, then the operation
>   *	causing setuid bit removal is failed.
> + * @inode_getsecid:
> + *      Get the secid associated with the node
> + *      @inode contains a pointer to the inode
> + *      @secid contains a pointer to the location to store the
> result *
>   * Security hooks for file operations
>   *
> @@ -989,6 +993,10 @@ struct request_sock;
>   *	@ipcp contains the kernel IPC permission structure
>   *	@flag contains the desired (requested) permission set
>   *	Return 0 if permission is granted.
> + * @ipc_getsecid:
> + *      Get the secid associated with the ipc object
> + *      @ipcp contains the kernel IPC permission structure
> + *      @secid contains a pointer to the location where result will
> be saved

See my other comments about tabs not spaces.

> +static inline void security_inode_getsecid(const struct inode
> *inode, u32 *secid)
> +{ } 

...

> +static inline void security_ipc_getsecid(struct kern_ipc_perm *ipcp,
> u32 *secid)
> +{ } 

Should these both do a  "*secid = 0;"?

> diff --git a/security/dummy.c b/security/dummy.c
> index 6a0056b..c2f4c52 100644
> --- a/security/dummy.c
> +++ b/security/dummy.c
> @@ -422,6 +422,11 @@ static int dummy_inode_listsecurity(struct inode
> *inode, char *buffer, size_t bu return 0;
>  }
>
> +static void dummy_inode_getsecid(const struct inode *inode, u32
> *secid)
> +{ 
> +	return;
> +}

...

> +static void dummy_ipc_getsecid(struct kern_ipc_perm *ipcp, u32
> *secid)
> +{ 
> +	return;
> +}

Same question.

-- 
paul moore
linux security @ hp
