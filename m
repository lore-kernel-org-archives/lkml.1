Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbZIVL33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbZIVL33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZIVL30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:29:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:43166 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZIVL3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:29:25 -0400
Subject: Re: [PATCH] Increase MAX_STACK_TRACE_ENTRIES
From: Peter Zijlstra <peterz@infradead.org>
To: John Kacur <jkacur@redhat.com>
Cc: mingo@elte.hu, tglx@linuxtronix.de, linux-kernel@vger.kernel.org,
       Clark Williams <williams@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0909211744230.6572@localhost.localdomain>
References: <alpine.LFD.2.00.0909211744230.6572@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 22 Sep 2009 13:29:22 +0200
Message-Id: <1253618962.7695.43.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 19:13 +0200, John Kacur wrote:
> Ingo: please consider this patch if there are no negative consequences to 
> increasing this value. It fixes a problem that we have seen in the past on
> (at least) the real-time kernel. (BUG: MAX_STACK_TRACE_ENTRIES).
> 
> This patch applies to the current tip/master

Hrmm,.. this is growing to be very large indeed.

It would be nice to know where all these extra entries are coming from.
How large are:

# cat /proc/lockdep | grep -v -e "\->" -e "^$" | wc -l
437

# cat /proc/lockdep | grep -v -e "\->" -e "^$" | awk '{print $6}' | 
                      tr -d ".:" | grep -v "^$" | wc -c
1031

On your machine?

> -#define MAX_STACK_TRACE_ENTRIES	262144UL
> +#define MAX_STACK_TRACE_ENTRIES	393216UL

