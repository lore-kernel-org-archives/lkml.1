Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbYGOXNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbYGOXNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbYGOXNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:13:16 -0400
Received: from ns.suse.de ([195.135.220.2]:52333 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbYGOXNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:13:15 -0400
Message-ID: <487D2F01.5000404@suse.de>
Date: Wed, 16 Jul 2008 08:13:05 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
Cc: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] sysfs: Support sysfs_notify from atomic context with
 new sysfs_notify_dirent
References: <18557.11132.728439.827572@notabene.brown>
In-Reply-To: <18557.11132.728439.827572@notabene.brown>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Neil Brown wrote:
> +#undef sysfs_get
> +struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd)
> +{
> +	return __sysfs_get(sd);
> +}
> +EXPORT_SYMBOL_GPL(sysfs_get);
> +
> +#undef sysfs_put
> +void sysfs_put(struct sysfs_dirent *sd)
> +{
> +	__sysfs_put(sd);
> +}
> +EXPORT_SYMBOL_GPL(sysfs_put);

I don't think this inline technique is really necessary.  Please just
drop the inline versions.  Other than that,

Acked-by: Tejun Heo <tj@kernel.org>

BTW, things like this strongly suggest that we really should switch to
sd-based interface instead of combination of kobj and optional name string.

Thanks.

-- 
tejun
