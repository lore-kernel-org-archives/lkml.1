Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbXKUKCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbXKUKCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 05:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbXKUKCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 05:02:04 -0500
Received: from relay1.sgi.com ([192.48.171.29]:53781 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752102AbXKUKCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 05:02:03 -0500
Message-Id: <20071121100201.156191000@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 21 Nov 2007 02:02:01 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>
Cc: mingo@elte.hu, apw@shadowen.org, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] x86: Reduce pressure on stack from cpumask usage -v2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


v2:
    - fix some compile errors when NR_CPUS > default for ia386 (128 & 4096)
    - remove unneccessary includes

Convert cpumask_of_cpu to use a static percpu data array and
set_cpus_allowed to pass the cpumask_t arg as a pointer.

Conditioned on NR_CPUS > BITS_PER_LONG.

Compiled and tested for i386 and x86_64.  I'd appreciate
feedback on other architectures.

(Note: there are still compile/test errors when NR_CPUS > 256
due to cpu id being 8 bits among other things.)

-- 
