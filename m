Return-Path: <linux-kernel-owner+w=401wt.eu-S1764057AbXGWQSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764057AbXGWQSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759151AbXGWQSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:18:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:59432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757092AbXGWQSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:18:04 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered unnecessarily
Date: Mon, 23 Jul 2007 18:13:26 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231813.26859.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 July 2007 18:05:58 Satyam Sharma wrote:
> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> [6/8] i386: bitops: Don't mark memory as clobbered unnecessarily
> 
> The goal is to let gcc generate good, beautiful, optimized code.


The first goal is correct code.

The reason for the memory barrier is to prevent other memory references
from being moved over the atomic reference.

e.g. when a bit is used to communicate with another CPU this might be dangerous.

I don't think it's a good idea to remove them. It'll likely introduce subtle
bugs. Atomic bitops tend to be so slow anyways that it doesn't make much
difference.

-Andi

