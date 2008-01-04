Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbYADKsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbYADKsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 05:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYADKsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 05:48:22 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:42682 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbYADKsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 05:48:20 -0500
Date: Fri, 4 Jan 2008 11:48:18 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       olof@lixom.net
Subject: Re: [patch 2/2] Add the end-of-trace marker and the module list to
	WARN_ON()
Message-ID: <20080104104818.GA8198@osiris.boeblingen.de.ibm.com>
References: <477D5340.9090809@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477D5340.9090809@linux.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 10:27:28PM +0100, Arjan van de Ven wrote:
>
> Another issue is that, unlike oopses, WARN_ON() doesn't currently printk
> the helpful "cut here" line, nor the "end of trace" marker.
> Now that WARN_ON() is out of line, the size increase due to this is
> minimal and it's worth adding.
>
> +static void print_oops_end_marker(void)
> +{
> +	init_oops_id();
> +	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
> +		(unsigned long long)oops_id);
> +}

There is also lib/bug.c which prints the "cut here" line but not the
"end of trace" line. Also it prints whatever it prints with a different
printk level.
Quite a few architectures use lib/bug.c also for WARN_ONs.
Maybe all the code should be in one place so it doesn't diverge all the
time?
