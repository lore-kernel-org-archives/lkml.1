Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYHLWBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYHLWBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYHLWBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:01:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44654
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbYHLWBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:01:39 -0400
Date: Tue, 12 Aug 2008 15:01:40 -0700 (PDT)
Message-Id: <20080812.150140.200481459.davem@davemloft.net>
To: divy@chelsio.com
Cc: rdreier@cisco.com, rick.jones2@hp.com, jgarzik@pobox.com,
       swise@opengridcomputing.com, kxie@chelsio.com, netdev@vger.kernel.org,
       open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, daisyc@us.ibm.com,
       wenxiong@us.ibm.com, bhua@us.ibm.com, dm@chelsio.com,
       leedom@chelsio.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
From: David Miller <davem@davemloft.net>
In-Reply-To: <200808121457.11356.divy@chelsio.com>
References: <adad4kfxm9v.fsf@cisco.com>
	<20080811.145313.178992274.davem@davemloft.net>
	<200808121457.11356.divy@chelsio.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Tue, 12 Aug 2008 14:57:09 -0700

> iSCSI PDUs might spawn over multiple TCP segments, it is unclear to me how to 
> do placement without keeping some state of the transactions.

You keep a flow table with buffer IDs and offsets.

The S2IO guys did something similar for one of their initial LRO
impelementations.

It's still strictly stateless, and best-effort.  Entries can fall out
of the flow cache which makes upcoming data use new buffers and
offsets.

But these are the kinds of tricks you hardware folks should be
more than adequately able to design, rather than me. :-)
