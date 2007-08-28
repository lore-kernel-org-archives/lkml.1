Return-Path: <linux-kernel-owner+w=401wt.eu-S1761889AbXH1U1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761889AbXH1U1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbXH1U1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:27:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50413
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753036AbXH1U1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:27:43 -0400
Date: Tue, 28 Aug 2007 13:27:41 -0700 (PDT)
Message-Id: <20070828.132741.118957759.davem@davemloft.net>
To: ossthema@de.ibm.com
Cc: jchapman@katalix.com, shemminger@linux-foundation.org, akepner@sgi.com,
       netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: RFC: issues concerning the next NAPI interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <200708281321.10679.ossthema@de.ibm.com>
References: <46D2F301.7050105@katalix.com>
	<20070827.140251.95055210.davem@davemloft.net>
	<200708281321.10679.ossthema@de.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Bernd Themann <ossthema@de.ibm.com>
Date: Tue, 28 Aug 2007 13:21:09 +0200

> So I guess one solution is to "force" an HW interrupt when two many
> RQs are processed on the same CPU (when no IRQ pinning is
> used). This is something the driver has to handle.

No, the solution is to lock the interrupts onto one specific
processor and don't move it around.  That's what's causing
all of the problems.

And you can enforce this policy now in the driver even if just
for testing by calling the set_affinity() interfaces on the
interrupts your driver has.

You can even walk over the cpu_online_map and choose a load
distribution of your liking.
