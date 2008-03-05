Return-Path: <linux-kernel-owner+w=401wt.eu-S1763863AbYCEWNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763863AbYCEWNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbYCEWNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:13:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756724AbYCEWNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:13:39 -0500
Date: Wed, 5 Mar 2008 14:12:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, systemtap@sourceware.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [patch 1/3]  Relay Reset Consumed
Message-Id: <20080305141229.d79d846b.akpm@linux-foundation.org>
In-Reply-To: <1204588311.32186.7.camel@lc4eb748232119.ibm.com>
References: <1204588311.32186.7.camel@lc4eb748232119.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Mar 2008 15:51:50 -0800
"David J. Wilder" <dwilder@us.ibm.com> wrote:

> This patch allows relay channels to be reset i.e. unconsumed.
> Basically allows a 'rewind' function for flight-recorder tracing.
> 
> +void relay_reset_consumed(struct rchan *chan)
> +{
> +	unsigned int i;
> +	struct rchan_buf *prev = NULL;
> +
> +	if (!chan)
> +		return;
> +
> +	for (i = 0; i < NR_CPUS; i++) {

Use of NR_CPUS is usually wrong.  In this case it seems you should be using
for_each_possible_cpu().

Also the existing usage of NR_CPUS in relay_subbufs_consumed() should be
switched to using cpu_possible().


New usage of NR_CPUS might be checkpatch-worthy, actually:

akpm:/usr/src/25> grep -l '^+.*NR_CPUS' patches/*.patch 
patches/ext4-mm-mballoc-core.patch
patches/git-kvm.patch
patches/git-perfmon.patch
patches/relay-reset-consumed.patch
patches/x86-andi-git-x86.patch
patches/x86-andi-smp-switch-optimize.patch

that's a sample of 1852 patches.

An appropriate warning would be "Usage of NR_CPUS is often wrong - should
you be using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(),
etc?".

