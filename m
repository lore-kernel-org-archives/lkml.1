Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbYKNARd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbYKNARd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYKNARZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:17:25 -0500
Received: from tundra.namei.org ([65.99.196.166]:53498 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbYKNARY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:17:24 -0500
Date: Fri, 14 Nov 2008 11:16:30 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, serue@us.ibm.com, morgan@kernel.org
Subject: Re: [PATCH] capabilities: define get_vfs_caps_from_disk when file
 caps are not enabled
In-Reply-To: <1226619445.3353.71.camel@localhost.localdomain>
Message-ID: <alpine.LRH.1.10.0811141115350.25835@tundra.namei.org>
References: <1226619445.3353.71.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008, Eric Paris wrote:

> When CONFIG_SECURITY_FILE_CAPABILITIES is not set the audit system may
> try to call into the capabilities function vfs_cap_from_file.  This
> patch defines that function so kernels can build and work.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> 
> ---
> 
>  security/commoncap.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 0b88160..574a70b 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -337,6 +337,12 @@ int cap_inode_killpriv(struct dentry *dentry)
>  	return 0;
>  }
>  
> +int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps)
> +{
> +	memset(cpu_caps, 0, sizeof(struct cpu_vfs_cap_data));
> +	return -ENODATA;
> +}
> +

As the function is returning an error, the caller should not depend on the 
state of any modifiable arguments, so I suggest removing the memset.


>  static inline int get_file_caps(struct linux_binprm *bprm)
>  {
>  	bprm_clear_caps(bprm);
> 
> 

-- 
James Morris
<jmorris@namei.org>
