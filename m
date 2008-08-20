Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbYHTFgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbYHTFgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 01:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbYHTFgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 01:36:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:53452 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbYHTFgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 01:36:12 -0400
Subject: Re: [PATCH 2/2] powerpc - Make the irq reverse mapping radix tree
	lockless
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, paulus@samba.org,
       michael@ellerman.id.au, jean-pierre.dion@bull.net,
       gilles.carry@ext.bull.net, tinytim@us.ibm.com, tglx@linutronix.de,
       rostedt@goodmis.org, dwalker@mvista.com
In-Reply-To: <1218029429-21114-3-git-send-email-sebastien.dugue@bull.net>
References: <1218029429-21114-1-git-send-email-sebastien.dugue@bull.net>
	 <1218029429-21114-3-git-send-email-sebastien.dugue@bull.net>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 15:23:01 +1000
Message-Id: <1219209781.21386.25.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW. It would be good to try to turn the GFP_ATOMIC into GFP_KERNEL,
maybe using a semaphore instead of a lock to protect insertion vs.
initialisation. The old scheme was fine because if the atomic allocation
failed, it could fallback to the linear search and try again on the next
interrupt. Not anymore.

Ben.


