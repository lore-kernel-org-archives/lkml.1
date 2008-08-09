Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbYHIH2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbYHIH2x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 03:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbYHIH2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 03:28:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36903
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752489AbYHIH2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 03:28:39 -0400
Date: Sat, 09 Aug 2008 00:28:40 -0700 (PDT)
Message-Id: <20080809.002840.167363463.davem@davemloft.net>
To: jgarzik@pobox.com
Cc: swise@opengridcomputing.com, divy@chelsio.com, rdreier@cisco.com,
       kxie@chelsio.com, netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
From: David Miller <davem@davemloft.net>
In-Reply-To: <489CC58D.4010606@pobox.com>
References: <200808071145.03848.divy@chelsio.com>
	<489C8BEB.8060001@opengridcomputing.com>
	<489CC58D.4010606@pobox.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jgarzik@pobox.com>
Date: Fri, 08 Aug 2008 18:15:41 -0400

> * security updates for TCP problems mean that a single IP address can be 
> PARTIALLY SECURE, because security updates for kernel TCP stack and 
> h/w's firmware are inevitably updated separately (even if distributed 
> and compiled together).  Yay, we are introducing a wonderful new 
> security problem here.
> 
> * from a security, network scanner and packet classifier point of view, 
> a single IP address no longer behaves like Linux.  It behaves like 
> Linux... sometime.  Depending on whether it is a magic TCP port or not.

I agree with everything Jeff has stated.

Also, I find it ironic that the port abduction is being asked for in
order to be "compatible with existing tools" yet in fact this stuff
breaks everything.  You can't netfilter this traffic, you can't apply
qdiscs to it, you can't execut TC actions on them, you can't do
segmentation offload on them, you can't look for the usual TCP MIB
statistics on the connection, etc. etc. etc.

It is broken from every possible angle.
