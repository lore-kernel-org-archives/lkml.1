Return-Path: <linux-kernel-owner+w=401wt.eu-S2993029AbXCIHLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993029AbXCIHLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993026AbXCIHLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:11:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39511
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2993028AbXCIHLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:11:54 -0500
Date: Thu, 08 Mar 2007 23:11:42 -0800 (PST)
Message-Id: <20070308.231142.74749203.davem@davemloft.net>
To: peter.p.waskiewicz.jr@intel.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       christopher.leech@intel.com
Subject: Re: [PATCH 0/2] NET: Multiple queue network device support REPOST
From: David Miller <davem@davemloft.net>
In-Reply-To: <D5C1322C3E673F459512FB59E0DDC329026E981A@orsmsx414.amr.corp.intel.com>
References: <20070308.222154.74746753.davem@davemloft.net>
	<D5C1322C3E673F459512FB59E0DDC329026E981A@orsmsx414.amr.corp.intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Date: Thu, 8 Mar 2007 22:42:19 -0800

> This was taken into consideration, and I did reply that my concern for
> doing that could cause stale data in the skb if the queue mapping
> changed.

This is not a problem.

Since the ->enqueue function stores references to the SKBs,
any change of the dev->qdisc has to flush those references
somehow, and it is at that point that you can fixup the
skb queue mappings.

This happens via invoking the qdisc->ops->reset() method.
