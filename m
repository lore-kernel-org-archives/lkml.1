Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZI2Svb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZI2Svb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 14:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZI2Sva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 14:51:30 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40432 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbZI2Sv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 14:51:29 -0400
Date: Tue, 29 Sep 2009 13:51:26 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: Oren Laadan <orenl@librato.com>, Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Dan Smith <danms@us.ibm.com>, Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [PATCH v18 49/80] c/r: support for UTS namespace
Message-ID: <20090929185126.GB13297@us.ibm.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com> <1253749920-18673-50-git-send-email-orenl@librato.com> <200909292213.21266@blacky.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909292213.21266@blacky.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Nikita V. Youshchenko (yoush@cs.msu.su):
> > +static struct uts_namespace *do_restore_uts_ns(struct ckpt_ctx *ctx)
> > ...
> > +#ifdef CONFIG_UTS_NS
> > +	uts_ns = create_uts_ns();
> > +	if (!uts_ns) {
> > +		uts_ns = ERR_PTR(-ENOMEM);
> > +		goto out;
> > +	}
> > +	down_read(&uts_sem);
> > +	name = &uts_ns->name;
> > +	memcpy(name->sysname, h->sysname, sizeof(name->sysname));
> > +	memcpy(name->nodename, h->nodename, sizeof(name->nodename));
> > +	memcpy(name->release, h->release, sizeof(name->release));
> > +	memcpy(name->version, h->version, sizeof(name->version));
> > +	memcpy(name->machine, h->machine, sizeof(name->machine));
> > +	memcpy(name->domainname, h->domainname, sizeof(name->domainname));
> > +	up_read(&uts_sem);
> 
> Could you please explain what for is this down_read() / up_read() ?
> You operate only on local objects: 'name' points to just-created 
> uts_ns, 'h' is also local data.

Yup, good point, that looks unnecessary.

thanks,
-serge
