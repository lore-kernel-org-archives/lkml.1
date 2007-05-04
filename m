Return-Path: <linux-kernel-owner+w=401wt.eu-S1767582AbXEDBi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767582AbXEDBi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 21:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767576AbXEDBi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 21:38:27 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58270 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767575AbXEDBi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 21:38:26 -0400
Date: Thu, 3 May 2007 18:38:21 -0700
From: Paul Jackson <pj@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, kenchen@google.com,
       agl@us.ibm.com, hermes@gibson.dropbear.id.au, wli@holomorphy.com,
       clameter@sgi.com
Subject: Re: + per-cpuset-hugetlb-accounting-and-administration.patch added
 to -mm tree
Message-Id: <20070503183821.b75e8f57.pj@sgi.com>
In-Reply-To: <200705040104.l4414YFR026322@shell0.pdx.osdl.net>
References: <200705040104.l4414YFR026322@shell0.pdx.osdl.net>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Christoph Lameter <clameter@sgi.com> to the cc list, as he knows
more about hugetlb pages than I do.

This patch strikes me as a bit odd.

Granted, it's solving what could be a touchy problem with a fairly
simple solution, which is usually a Good Thing(tm).

However, the idea that different tasks would see different values for
the following fields in /proc/meminfo:

	HugePages_Total:     0
	HugePages_Free:      0

strikes me as odd, and risky.  I would have thought that usually, all
tasks in the system should see the same values in the files in /proc
(as opposed to the files in particular task subdirectories /proc/<pid>.)

This patch strikes me as a bit of a hack, good for compatibility, but
hiding a booby trap that will bite some user code in the long run.

But I'm not enough of an expert to know what the right tradeoffs are
in this matter.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
