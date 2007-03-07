Return-Path: <linux-kernel-owner+w=401wt.eu-S1422634AbXCGJHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422634AbXCGJHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422636AbXCGJHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:07:46 -0500
Received: from mail8.tpgi.com.au ([203.12.160.46]:44906 "EHLO
	mail8.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422634AbXCGJHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:07:43 -0500
X-TPG-Antivirus: Passed
Subject: Re: [ckrm-tech] [PATCH 3/3][RFC] Containers: Pagecache controller
	reclaim
From: Shane <ibm-main@tpg.com.au>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: riel@redhat.com, vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net,
       balbir@in.ibm.com, linux-kernel@vger.kernel.org, xemul@sw.ru,
       linux-mm@kvack.org, menage@google.com, devel@openvz.org,
       clameter@sgi.com
In-Reply-To: <45ED4CF7.7030501@linux.vnet.ibm.com>
References: <20070305145237.003560000@linux.vnet.ibm.com> >
	 <20070305145311.247699000@linux.vnet.ibm.com> >
	 <1173178212.4998.54.camel@localhost.localdomain>
	 <45ED4CF7.7030501@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 19:03:59 +1000
Message-Id: <1173258239.4998.79.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 16:43 +0530, Vaidyanathan Srinivasan wrote:
> 
> Please let me know if so see any problem running the patch.  The
> patches are against 2.6.20 only since dependent patches are at that level.

My problem - a bad copy of the patch. It patches o.k.
However, it fails to compile vmscan. This looks a bit dodgy;

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

@@ -1470,11 +1494,13 @@ unsigned long shrink_all_memory(unsigned
        int pass;
        struct reclaim_state reclaim_state;
        struct scan_control sc = {
-               .gfp_mask = GFP_KERNEL,
+               .gfp_mask = GFdefined(CONFIG_CONTAINER_PAGECACHE_ACCT)
+P_KERNEL,

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

I deleted what looks like an over-enthusiastic "copy-and-paste", and it
compiled o.k.
Testing continues.

Shane ...

