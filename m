Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbZI2XBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbZI2XBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 19:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbZI2XBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 19:01:13 -0400
Received: from smtp151.iad.emailsrvr.com ([207.97.245.151]:46907 "EHLO
	smtp151.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZI2XBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 19:01:12 -0400
Message-ID: <4AC291B9.4060204@librato.com>
Date: Tue, 29 Sep 2009 19:01:13 -0400
From: Oren Laadan <orenl@librato.com>
Organization: Librato
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Nikita V. Youshchenko" <yoush@cs.msu.su>
CC: Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Smith <danms@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [PATCH v18 49/80] c/r: support for UTS namespace
References: <1253749920-18673-1-git-send-email-orenl@librato.com> <1253749920-18673-50-git-send-email-orenl@librato.com> <200909292213.21266@blacky.localdomain>
In-Reply-To: <200909292213.21266@blacky.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Nikita V. Youshchenko wrote:
>> +static struct uts_namespace *do_restore_uts_ns(struct ckpt_ctx *ctx)
>> ...
>> +#ifdef CONFIG_UTS_NS
>> +	uts_ns = create_uts_ns();
>> +	if (!uts_ns) {
>> +		uts_ns = ERR_PTR(-ENOMEM);
>> +		goto out;
>> +	}
>> +	down_read(&uts_sem);
>> +	name = &uts_ns->name;
>> +	memcpy(name->sysname, h->sysname, sizeof(name->sysname));
>> +	memcpy(name->nodename, h->nodename, sizeof(name->nodename));
>> +	memcpy(name->release, h->release, sizeof(name->release));
>> +	memcpy(name->version, h->version, sizeof(name->version));
>> +	memcpy(name->machine, h->machine, sizeof(name->machine));
>> +	memcpy(name->domainname, h->domainname, sizeof(name->domainname));
>> +	up_read(&uts_sem);
> 
> Could you please explain what for is this down_read() / up_read() ?
> You operate only on local objects: 'name' points to just-created 
> uts_ns, 'h' is also local data.

Nothing more than symmetry with checkpoint code, and a pedagogical
aspect...

Can be replaced by a suitable comment.

Oren.
