Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903Ab0ARVPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0ARVPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791Ab0ARVPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:15:00 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:42993 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab0ARVPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:15:00 -0500
Subject: Re: [PATCH] list.h: add list_for_each_struct_entry macro
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jiri Pirko <jpirko@redhat.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org
In-Reply-To: <20100118210718.GC4521@psychotron.redhat.com>
References: <20100118162338.GD4229@psychotron.lab.eng.brq.redhat.com>
	 <1263835033.3667.23.camel@achroite.uk.solarflarecom.com>
	 <20100118210718.GC4521@psychotron.redhat.com>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Mon, 18 Jan 2010 21:14:18 +0000
Message-Id: <1263849258.3667.43.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jan 2010 21:15:09.0686 (UTC) FILETIME=[50C75960:01CA9883]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17138.005
X-TM-AS-Result: No--19.367900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 22:07 +0100, Jiri Pirko wrote:
> Mon, Jan 18, 2010 at 06:17:13PM CET, bhutchings@solarflare.com wrote:
[...]
> >#define list_for_each_struct_entry(pos, head, type, posmember, member)	     \
> >	for (pos = list_empty(head) ? NULL :				     \
> >		&list_first_entry(head, type, member)->posmember;	     \
> >	     prefetch(container_of(pos, type, posmember)->member.next), pos; \
> >	     pos = list_is_last(&container_of(pos, type, posmember)->member, \
> >				head) ?	NULL :				     \
> >		&list_entry(container_of(pos, type, posmember)->member.next, \
> >			    type, member)->posmember)
> >
> 
> At the first glance, this would take even more cputime for lists longer
> than 2 or so, wouldn't it?

If you're concerned about speed, measure it, don't guess.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

