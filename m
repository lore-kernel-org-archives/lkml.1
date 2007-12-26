Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901AbXLZWub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbXLZWub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 17:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbXLZWr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 17:47:26 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60523 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbXLZWrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 17:47:24 -0500
To: linux-kernel@vger.kernel.org
cc: "lewis_zyxel" <lachang.li@zyxel.com.tw>
Subject: Re: 2 ports could not bond to a aggregator in 802.3ad mode issue 
In-reply-to: <20071226141301.8231163b.akpm@linux-foundation.org> 
References: <001201c846c9$6d03de40$431a17ac@ZyXEL.com> <20071226141301.8231163b.akpm@linux-foundation.org>
Comments: In-reply-to Andrew Morton <akpm@linux-foundation.org>
   message dated "Wed, 26 Dec 2007 14:13:01 -0800."
X-Mailer: MH-E 8.0.3; nmh 1.1-RC4; GNU Emacs 22.0.95
Date: Wed, 26 Dec 2007 14:47:16 -0800
Message-ID: <23058.1198709236@death>
From: Jay Vosburgh <fubar@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>After the setting, I cat the proc entry and got the following information
[...]
>802.3ad info
>LACP rate: slow
>Active Aggregator Info:
>        Aggregator ID: 1
>        Number of ports: 2
>        Actor Key: 17
>        Partner Key: 1
>        Partner Mac Address: 00:00:00:00:00:00
[...]
>The behavior changes from 'one aggregator with one port'  to 'one aggregator 
>with 2 ports', the latter seems more accurate. Is there a bug in bonding 
>driver code v3.1.3 (June 13, 2007)?

	I do not believe so.

	IEEE 802.3 section 43.3.9 states, in part,

	"Links that are not successful candidates for aggregation (e.g.,
links that are attached to other devices that cannot perform aggregation
or links that have been manually configured to be non-aggregatable) are
enabled to operate as individual IEEE 802.3 links. For consistency of
modeling, such a link is regarded as being attached to a compatible
Aggregator that can only be associated with a single link. That is, from
the perspective of Link Aggregation, non-aggregated links are not a
special case; they compose an aggregation with a maximum membership of
one link."

	I do not see that it is correct to attach the links to a common
aggregator, as your output indicates that no partner association has
been created (the Partner MAC is all zeroes) and the links are therefore
apparently connected to a device that cannot perform aggregation.

	-J

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
