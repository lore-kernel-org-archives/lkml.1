Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbYESMJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbYESMJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbYESMIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:08:52 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:57776 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbYESMIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:08:51 -0400
Subject: Re: [PATCH] selinux: reorder inode_security_struct to increase
	objs/slab on 64bit
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: jmorris@namei.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1211110377.3021.8.camel@castor.localdomain>
References: <1211110377.3021.8.camel@castor.localdomain>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 19 May 2008 07:39:45 -0400
Message-Id: <1211197185.7486.0.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-05-18 at 12:32 +0100, Richard Kennedy wrote:
> reorder inode_security_struct to remove padding on 64 bit builds
>     
> size reduced from 72 to 64 bytes increasing objects per slab to 64.
>         
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> 
> ---
> This patch is against 2.6.26-r2 & boots successfully on my AMD64
> desktop.
> 
> 
> Richard
> 
> 
> 
> diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
> index 032c235..5f0be19 100644
> --- a/security/selinux/include/objsec.h
> +++ b/security/selinux/include/objsec.h
> @@ -43,8 +43,8 @@ struct inode_security_struct {
>  	u32 sid;		/* SID of this object */
>  	u16 sclass;		/* security class of this object */
>  	unsigned char initialized;	/* initialization flag */
> -	struct mutex lock;
>  	unsigned char inherit;	/* inherit SID from parent entry */

Let's just drop inherit altogether - dead field.

> +	struct mutex lock;
>  };
>  
>  struct file_security_struct {
> 
-- 
Stephen Smalley
National Security Agency

