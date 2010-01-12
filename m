Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989Ab0ALUtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab0ALUtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 15:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259Ab0ALUtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 15:49:22 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:59659 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab0ALUtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 15:49:21 -0500
Date: Tue, 12 Jan 2010 14:48:17 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] use nr_cpus= to set nr_cpu_ids early
In-Reply-To: <1263298146-25597-1-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.00.1001121436080.25925@router.home>
References: <1263298146-25597-1-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trouble is that NR_CPUS is used all over the place. If nr_cpu_ids <
NR_CPUS at boot then there is a danger of for loops to NR_CPUS going out
of
bounds.

CONFIG_NR_CPUS is used for various bitmaps so that seems to be
okay.

drivers/acpi/numa.c:acpi_numa_init probably should use nr_cpu_ids
instead now.

There is an octeon driver in staging that has some issues with NR_CPUS as
well.




