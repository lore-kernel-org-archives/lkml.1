Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbZI2SON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbZI2SON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 14:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZI2SOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 14:14:12 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:44908 "EHLO lvk.cs.msu.su"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbZI2SOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 14:14:11 -0400
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: Oren Laadan <orenl@librato.com>
Subject: Re: [PATCH v18 49/80] c/r: support for UTS namespace
Date: Tue, 29 Sep 2009 22:13:17 +0400
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Smith <danms@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>
References: <1253749920-18673-1-git-send-email-orenl@librato.com> <1253749920-18673-50-git-send-email-orenl@librato.com>
In-Reply-To: <1253749920-18673-50-git-send-email-orenl@librato.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909292213.21266@blacky.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static struct uts_namespace *do_restore_uts_ns(struct ckpt_ctx *ctx)
> ...
> +#ifdef CONFIG_UTS_NS
> +	uts_ns = create_uts_ns();
> +	if (!uts_ns) {
> +		uts_ns = ERR_PTR(-ENOMEM);
> +		goto out;
> +	}
> +	down_read(&uts_sem);
> +	name = &uts_ns->name;
> +	memcpy(name->sysname, h->sysname, sizeof(name->sysname));
> +	memcpy(name->nodename, h->nodename, sizeof(name->nodename));
> +	memcpy(name->release, h->release, sizeof(name->release));
> +	memcpy(name->version, h->version, sizeof(name->version));
> +	memcpy(name->machine, h->machine, sizeof(name->machine));
> +	memcpy(name->domainname, h->domainname, sizeof(name->domainname));
> +	up_read(&uts_sem);

Could you please explain what for is this down_read() / up_read() ?
You operate only on local objects: 'name' points to just-created 
uts_ns, 'h' is also local data.
