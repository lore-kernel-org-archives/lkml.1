Return-Path: <linux-kernel-owner+w=401wt.eu-S1762691AbYHEBIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762691AbYHEBIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 21:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYHEBGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 21:06:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:35991 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbYHEBGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 21:06:50 -0400
Subject: Re: [PATCH 1/3] powerpc - Initialize the irq radix tree earlier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, paulus@samba.org,
       michael@ellerman.id.au, jean-pierre.dion@bull.net,
       gilles.carry@ext.bull.net, tinytim@us.ibm.com, tglx@linutronix.de,
       rostedt@goodmis.org
In-Reply-To: <1217898226.24157.120.camel@pasglop>
References: <1217848124-3719-1-git-send-email-sebastien.dugue@bull.net>
	 <1217848124-3719-2-git-send-email-sebastien.dugue@bull.net>
	 <1217898226.24157.120.camel@pasglop>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 11:05:03 +1000
Message-Id: <1217898303.24157.122.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  - Remove the populating of the tree from the revmap function as
>    you already do
>  - Move it to irq_create_mapping() for the normal case
>  - For pre-existing interrupt, have the generic code that initializes
>    the radix tree walk through all interrupts and setup the revmap for
>    them. If that needs locking vs. concurrent irq_create_mapping, it's
>    easy to use one of the available spinlocks for that.

And in fact, you may even be able to avoid GFP_ATOMIC completely here
and switch it to GFP_KERNEL since irq_create_mapping() can sleep afaik,
provided that you avoid the spinlocking.

Ben.


