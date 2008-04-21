Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbYDUPlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbYDUPlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbYDUPlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:41:08 -0400
Received: from ozlabs.org ([203.10.76.45]:32950 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbYDUPlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:41:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Subject: Re: [RFC PATCH 5/8] module: add function to map address to containing module
Date: Tue, 22 Apr 2008 01:40:58 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, ltp-list@lists.sourceforge.net,
       ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
References: <480C89DF.9090905@de.ibm.com>
In-Reply-To: <480C89DF.9090905@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804220140.58784.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 April 2008 22:34:39 Peter Oberparleiter wrote:
> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
>
> module_address() maps an address to the module containing it in either
> text or data section. Required by the gcov profiling infrastructure to
> associate profiling data structures with modules.

Locking problem; this isn't safe.  Note that we block preemption to traverse 
the module list.  You could grab a reference, and fix up all the callers to 
put it once they're done?

Thanks,
Rusty.
