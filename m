Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458Ab0ALWXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab0ALWXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 17:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217Ab0ALWXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 17:23:37 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:49736 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab0ALWXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 17:23:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Yp9Ux25/Z6BbyFhbArx555xewHdb9IyKFrtLxVzvCqkpT81JmZUYA7mIFvccHV54j9
         ZldCHKQHnBwEMpB2mDDBvpPsuIeBQ8l3JoaLur+LhbPCVGk5UHxFDffmm/S+HCPZqOoy
         ZUNBOAq3QegqmOZlnv4zeitbRewSUZAY1u9cI=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1001121436080.25925@router.home>
References: <1263298146-25597-1-git-send-email-yinghai@kernel.org>
	 <alpine.DEB.2.00.1001121436080.25925@router.home>
Date: Tue, 12 Jan 2010 14:23:35 -0800
X-Google-Sender-Auth: 5408bb1666159ada
Message-ID: <86802c441001121423h612ce0e4j9ff21e083340f00@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] use nr_cpus= to set nr_cpu_ids early
From: Yinghai Lu <yinghai@kernel.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 12:48 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> Trouble is that NR_CPUS is used all over the place. If nr_cpu_ids <
> NR_CPUS at boot then there is a danger of for loops to NR_CPUS going out
> of
> bounds.
>
> CONFIG_NR_CPUS is used for various bitmaps so that seems to be
> okay.

cpumask_var?

>
> drivers/acpi/numa.c:acpi_numa_init probably should use nr_cpu_ids
> instead now.

before prefill_possible_map for x86
before setup_nr_cpu_ids for other platform

nr_cpu_ids = NR_CPUS = CONFIG_NR_CPUS

>
> There is an octeon driver in staging that has some issues with NR_CPUS as
> well.
>

that should be fixed, we should use nr_cpu_ids instead for them.

YH
