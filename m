Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbYLRVgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbYLRVgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 16:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYLRVgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:36:36 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:34803 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbYLRVgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:36:35 -0500
Date: Thu, 18 Dec 2008 15:36:33 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 2/2] ipc namespaces: implement support for posix
	msqueues
Message-ID: <20081218213633.GA20733@us.ibm.com>
References: <20081217175513.GA23291@us.ibm.com> <20081217175549.GB23331@us.ibm.com> <20081217212521.GA14740@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217212521.GA14740@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sukadev Bhattiprolu (sukadev@linux.vnet.ibm.com):
> |  static int mqueue_get_sb(struct file_system_type *fs_type,
> |  			 int flags, const char *dev_name,
> |  			 void *data, struct vfsmount *mnt)
> |  {
> | -	return get_sb_single(fs_type, flags, data, mqueue_fill_super, mnt);
> | +	if (flags & MS_KERNMOUNT)
> | +		return get_sb_single_ns(fs_type, flags, data,
> | +					mqueue_fill_super, mnt);
> | +	return get_sb_single_ns(fs_type, flags, current->nsproxy->ipc_ns,
> | +				mqueue_fill_super, mnt);
> 
> nit. This maybe easier to read with an ns local variable and a single
> call to get_sb_single_ns().

The first time I read this I completely misunderstood what you
meant.  Yes, that's nicer.  Thanks for taking a look.

New version coming tomorrow (I want to stress this a bit).

thanks,
-serge
