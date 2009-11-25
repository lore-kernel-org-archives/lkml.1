Return-Path: <linux-kernel-owner+w=401wt.eu-S934297AbZKYDWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934297AbZKYDWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 22:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934246AbZKYDWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 22:22:53 -0500
Received: from ozlabs.org ([203.10.76.45]:32891 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933742AbZKYDWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 22:22:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19212.41731.446119.833036@cargo.ozlabs.ibm.com>
Date: Wed, 25 Nov 2009 14:22:43 +1100
From: Paul Mackerras <paulus@samba.org>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] CPU DLPAR  handling
In-Reply-To: <4B0C8E31.9040608@austin.ibm.com>
References: <4B0C8B45.6080804@austin.ibm.com>
	<4B0C8E31.9040608@austin.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Fontenot writes:

> Register the pseries specific handlers for the powerpc architecture handlers
> for the cpu probe and release files.  This also implements the cpu DLPAR
> addition and removal of CPUS from the system.

...

> +	/* configure-connector reports cpus as living in the base
> +	 * directory of the device tree.  CPUs actually live in the
> +	 * cpus directory so we need to fixup the full_name.
> +	 */
> +	cpu_name = kzalloc(strlen(dn->full_name) + strlen("/cpus/") + 1,
> +			   GFP_KERNEL);
> +	if (!cpu_name) {
> +		dlpar_free_cc_nodes(dn);
> +		return -ENOMEM;
> +	}
> +
> +	sprintf(cpu_name, "/cpus/%s", dn->full_name);

I would have expected dn->full_name to start with a '/' already, in
which case this will end up with two consecutive slashes after
'cpus'.  I think that will probably cause problems.

Paul.
