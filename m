Return-Path: <linux-kernel-owner+w=401wt.eu-S1756446AbZIRNC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbZIRNC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 09:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbZIRNCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 09:02:25 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:10690 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbZIRNCY convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;2:1>);
	Fri, 18 Sep 2009 09:02:24 -0400
Message-Id: <4AB3A1040200007800015BD3@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 18 Sep 2009 14:02:28 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <borislav.petkov@amd.com>, <dougthompson@xmission.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: amd64_edac making improper assumptions?
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug, Borislav,

the sizing of pvt_lookup[] and mci_lookup[] is done based on a config
setting (CONFIG_NODES_SHIFT), and the indexing happens using the
raw value read from hardware without any bounds checking. Hence,
running a kernel with e.g. !CONFIG_NUMA on a multi-socket system
would happily access other than the first and only array element.

Likewise, the use of rdmsr_on_cpu() doesn't seem to do what is
intended when !CONFIG_NUMA.

Also, assuming you can use cpumask_of_node() directly on the
node ID read from hardware seems bogus (even in general, but
namely again when MAX_NUMNODES is less than the actual number
of nodes).

Thanks for your explanation,
Jan

