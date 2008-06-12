Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYFLH2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYFLH2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 03:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbYFLH15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 03:27:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:50932 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517AbYFLH15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 03:27:57 -0400
Subject: Re: [PATCH REPOST] IB/ehca: In case of lost interrupts, trigger
	EOI to reenable interrupts
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: Roland Dreier <rolandd@cisco.com>, Paul Mackerras <paulus@samba.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, OF-EWG <ewg@lists.openfabrics.org>,
       general@lists.openfabrics.org, TKLEIN@de.ibm.com, fenkes@de.ibm.com,
       raisch@de.ibm.com, THEMANN@de.ibm.com
In-Reply-To: <200806101644.34693.ossrosch@linux.vnet.ibm.com>
References: <200806101644.34693.ossrosch@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 17:23:15 +1000
Message-Id: <1213255395.14478.28.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-10 at 16:44 +0200, Stefan Roscher wrote:
> During corner case testing, we noticed that some versions of ehca 
> do not properly transition to interrupt done in special load situations.
> This can be resolved by periodically triggering EOI through H_EOI, 
> if eqes are pending.
> 
> Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>

This patch is fine with me as long as the FW/HW people can confirm that
calling spurrious EOI's like that will not affect other interrupts.

The side effect of writing 0xff to the xirr should be irrelevant as long as
this is not done from within a HW interrupt handler (timer interrupts or
softirqs are fine).

Due to the already incestuous relationship between HCA and the hypervisor,
I don't mind having the H call directly in the driver.

So as long as the FW/HW people are ok with that workaround, then it has
my ack as well.

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---



