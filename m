Return-Path: <linux-kernel-owner+w=401wt.eu-S932532AbYCGVDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbYCGVDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 16:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759515AbYCGVC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 16:02:57 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:57289 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871AbYCGVC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 16:02:56 -0500
Message-ID: <47D1AD35.6010102@oracle.com>
Date: Fri, 07 Mar 2008 13:01:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Pierre Peiffer <peifferp@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25-rc3-mm1] IPC: fix a kernel-doc warning
References: <878847400803071236w47178fa4r79f50d537b383843@mail.gmail.com>
In-Reply-To: <878847400803071236w47178fa4r79f50d537b383843@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Peiffer wrote:
> Hi,
> 
> This patch fixes this warning produced by kernel-doc (thanks Randy Dunlap):
> 
> Warning(linux-2.6.25-rc3-mm1//ipc/util.c:845):
> No description found for parameter 'extrat_perm'
> 
> It is due to an inconsistency in a variable name between the C-code and
> the associated comment.
> 
> Signed-off-by: Pierre Peiffer <peifferp@gmail.com>

Thanks, looks good.
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
>  ipc/util.c |    4 ++--
>  ipc/util.h |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> Index: b/ipc/util.c
> ===================================================================
> --- a/ipc/util.c
> +++ b/ipc/util.c
> @@ -841,7 +841,7 @@
>   *    or an err-code without any lock held otherwise.
>   */
>  struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
> -				      struct ipc64_perm *perm, int extrat_perm)
> +				      struct ipc64_perm *perm, int extra_perm)
>  {
>  	struct kern_ipc_perm *ipcp;
>  	int err;
> @@ -858,7 +858,7 @@
>  		goto out_unlock;
> 
>  	if (cmd == IPC_SET) {
> -		err = audit_ipc_set_perm(extrat_perm, perm->uid,
> +		err = audit_ipc_set_perm(extra_perm, perm->uid,
>  					 perm->gid, perm->mode);
>  		if (err)
>  			goto out_unlock;
> Index: b/ipc/util.h
> ===================================================================
> --- a/ipc/util.h
> +++ b/ipc/util.h
> @@ -114,7 +114,7 @@
>  void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out);
>  void ipc_update_perm(struct ipc64_perm *in, struct kern_ipc_perm *out);
>  struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
> -				      struct ipc64_perm *perm, int extrat_perm);
> +				      struct ipc64_perm *perm, int extra_perm);
> 
>  #if defined(__ia64__) || defined(__x86_64__) || defined(__hppa__) ||
> defined(__XTENSA__)
>    /* On IA-64, we always use the "64-bit version" of the IPC structures.  */
> 


-- 
~Randy
