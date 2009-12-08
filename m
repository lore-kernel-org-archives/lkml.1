Return-Path: <linux-kernel-owner+w=401wt.eu-S935778AbZLHGIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935778AbZLHGIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 01:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932385AbZLHGIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 01:08:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57104 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932381AbZLHGIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 01:08:13 -0500
Message-ID: <4B1DED36.8080204@cn.fujitsu.com>
Date: Tue, 08 Dec 2009 14:07:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ben Blum <bblum@andrew.cmu.edu>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com, netdev@vger.kernel.org
Subject: Re: [RFC] [PATCH 3/5] cgroups: net_cls as module
References: <20091204085349.GA18867@andrew.cmu.edu> <20091204085712.GC18912@andrew.cmu.edu>
In-Reply-To: <20091204085712.GC18912@andrew.cmu.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +struct cgroup_subsys net_cls_subsys = {
> +	.name		= "net_cls",
> +	.create		= cgrp_create,
> +	.destroy	= cgrp_destroy,
> +	.populate	= cgrp_populate,
> +#ifdef CONFIG_NET_CLS_CGROUP
> +	.subsys_id	= net_cls_subsys_id,
> +#else
> +#define net_cls_subsys_id net_cls_subsys.subsys_id
> +#endif

This looks a bit odd. I think below is the more standard way:

#ifndef MODULES
...
#else
...
#endif

> +	.module		= THIS_MODULE,
> +};


