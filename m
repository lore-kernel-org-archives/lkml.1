Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbYA0L4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbYA0L4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 06:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYA0L4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 06:56:05 -0500
Received: from ozlabs.org ([203.10.76.45]:41565 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbYA0L4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 06:56:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18332.28991.658933.763115@cargo.ozlabs.ibm.com>
Date: Sun, 27 Jan 2008 22:55:43 +1100
From: Paul Mackerras <paulus@samba.org>
To: balbir@linux.vnet.ibm.com
Cc: Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC (Take 2)
In-Reply-To: <20080126071339.GA25328@balbir.in.ibm.com>
References: <20071207223714.11448.91386.sendpatchset@balbir-laptop>
	<1200634493.7806.0.camel@concordia.ozlabs.ibm.com>
	<1200635099.7806.3.camel@concordia.ozlabs.ibm.com>
	<20080126071339.GA25328@balbir.in.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh writes:

> Here's a better and more complete fix for the problem. Could you
> please see if it works for you? I tested it on a real NUMA box and it
> seemed to work fine there.

There are a couple of other changes in behaviour that your patch
introduces, and I'd like to understand them better before taking the
patch.  First, with your patch we don't set nodes online if they end
up having no memory in them because of the memory limit, whereas
previously we did.  Secondly, in the case where we don't have NUMA
information, we now set node 0 online after adding each LMB, whereas
previously we only set it online once.

If in fact these changes are benign, then your patch description
should mention them and explain why they are benign.

Paul.
