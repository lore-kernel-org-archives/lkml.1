Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYAHSNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYAHSNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYAHSNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:13:11 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47166 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbYAHSNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:13:09 -0500
Subject: Re: [patch 5/9] unprivileged mounts: allow unprivileged bind mounts
From: Dave Hansen <haveblue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, ebiederm@xmission.com, kzak@redhat.com,
       linux-fsdevel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080108113626.895583537@szeredi.hu>
References: <20080108113502.184459371@szeredi.hu>
	 <20080108113626.895583537@szeredi.hu>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 10:12:38 -0800
Message-Id: <1199815958.9834.58.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-08 at 12:35 +0100, Miklos Szeredi wrote:
> +static int reserve_user_mount(void)
> +{
> +       int err = 0;
> +
> +       spin_lock(&vfsmount_lock);
> +       if (nr_user_mounts >= max_user_mounts && !capable(CAP_SYS_ADMIN))
> +               err = -EPERM;
> +       else
> +               nr_user_mounts++;
> +       spin_unlock(&vfsmount_lock);
> +       return err;
> +} 

Would -ENOSPC or -ENOMEM be a more descriptive error here?  

-- Dave

