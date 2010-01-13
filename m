Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293Ab0AMKCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab0AMKCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227Ab0AMKCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:02:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35287 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212Ab0AMKCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:02:32 -0500
Date: Wed, 13 Jan 2010 11:00:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 5/5] lockdep: Fix the way to initialize class_mutex for
 information of file and line
Message-ID: <20100113100022.GA11386@elte.hu>
References: <4B45B9C1.2040900@dcl.info.waseda.ac.jp>
 <1262860795-5745-6-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262860795-5745-6-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> This patch adds __FILE__ and __LINE__ to arguments passed for
> __mutex_init() called in __class_register().
> This affects to lockdep_map of class_mutex of struct class_private,
> and these will be used to make trace lock events more human friendly.
> 
> Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/base/class.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/class.c b/drivers/base/class.c
> index 161746d..cc0630f 100644
> --- a/drivers/base/class.c
> +++ b/drivers/base/class.c
> @@ -162,7 +162,8 @@ int __class_register(struct class *cls, struct lock_class_key *key)
>  	klist_init(&cp->class_devices, klist_class_dev_get, klist_class_dev_put);
>  	INIT_LIST_HEAD(&cp->class_interfaces);
>  	kset_init(&cp->class_dirs);
> -	__mutex_init(&cp->class_mutex, "struct class mutex", key);
> +	__mutex_init(&cp->class_mutex, "struct class mutex", key,
> +		     __FILE__, __LINE__);
>  	error = kobject_set_name(&cp->class_subsys.kobj, "%s", cls->name);
>  	if (error) {
>  		kfree(cp);

Greg, any objection to this type of embellishment of lock data that comes from 
the driver core?

Thanks,

	Ingo
