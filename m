Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbYHNCHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbYHNCHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 22:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYHNCHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 22:07:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44294
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751934AbYHNCHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 22:07:05 -0400
Date: Wed, 13 Aug 2008 19:07:06 -0700 (PDT)
Message-Id: <20080813.190706.251724821.davem@davemloft.net>
To: tom@opengridcomputing.com
Cc: rdreier@cisco.com, rick.jones2@hp.com, jgarzik@pobox.com,
       swise@opengridcomputing.com, divy@chelsio.com, kxie@chelsio.com,
       netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
From: David Miller <davem@davemloft.net>
In-Reply-To: <48A390F4.5080101@opengridcomputing.com>
References: <48A389DB.9050002@opengridcomputing.com>
	<20080813.183755.72334968.davem@davemloft.net>
	<48A390F4.5080101@opengridcomputing.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Tucker <tom@opengridcomputing.com>
Date: Wed, 13 Aug 2008 20:57:08 -0500

> I'm not trying to be pedantic here but let me try and restate what I 
> think you said above:
> 
> - The "header" traverses the real networking stack
> - The "payload" is placed either by by the hardware if possible or by 
> the native stack if on the exception path
> - The "header" may aggregate multiple  PDU (RSO)
> - Data ready indications are controlled entirely by the software/real 
> networking stack

SKB's can be paged, in fact many devices already work by chopping
up lists of pages that the driver gives to the card.  NIU is one
of several examples.

The only difference between what a device like NIU is doing now and
what I propose is smart determination of at what offset and into
which buffers to do the demarcation.
