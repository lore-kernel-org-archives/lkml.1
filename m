Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbZCKLQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbZCKLQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 07:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbZCKLQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 07:16:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36032 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbZCKLQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 07:16:19 -0400
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       herbert@gondor.apana.org.au, jesse.brandeburg@intel.com,
       shemminger@vyatta.com, David Miller <davem@davemloft.net>
Subject: Re: [RFC v2: Patch 1/3] net: hand off skb list to other cpu to submit to upper layer
From: Andi Kleen <andi@firstfloor.org>
References: <1236761624.2567.442.camel@ymzhang>
Date: Wed, 11 Mar 2009 12:13:58 +0100
In-Reply-To: <1236761624.2567.442.camel@ymzhang> (Yanmin Zhang's message of "Wed, 11 Mar 2009 16:53:44 +0800")
Message-ID: <877i2wfh1l.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Zhang, Yanmin" <yanmin_zhang@linux.intel.com> writes:

> I got some comments. Special thanks to ﻿Stephen Hemminger for teaching me on
> what reorder is and some other comments. Also thank other guys who raised comments.


>
> v2 has some improvements.
> 1) Add new sysfs interface /sys/class/net/ethXXX/rx_queueXXX/processing_cpu. Admin
> could use it to configure the binding between RX and cpu number. So it's convenient
> for drivers to use the new capability.

Seems very inconvenient to have to configure this by hand. How about
auto selecting one that shares the same LLC or somesuch? Passing
data to anything with the same LLC should be cheap enough.

BTW the standard idea to balance processing over multiple CPUs was to
use MSI-X to multiple CPUs. and just use the hash function on the
NIC. Have you considered this for forwarding too? The trick here would
be to try to avoid reordering inside streams as far as possible, but
since the NIC hash should work on flow basis that should be ok.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
