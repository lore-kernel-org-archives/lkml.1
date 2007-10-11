Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbXJKFwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbXJKFwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 01:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbXJKFwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 01:52:12 -0400
Received: from ozlabs.org ([203.10.76.45]:45665 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbXJKFwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 01:52:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18189.47620.466515.645055@cargo.ozlabs.ibm.com>
Date: Thu, 11 Oct 2007 15:52:04 +1000
From: Paul Mackerras <paulus@samba.org>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, linuxppc-dev@ozlabs.org,
       tgall.foo@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Subject: Re: [PATCH v2] powerpc: don't enable cpu hotplug on mpic-based pseries
In-Reply-To: <20071010003824.GA8477@lixom.net>
References: <20071008180406.052382073@mini.kroah.org>
	<20071008180633.GJ7627@kroah.com>
	<20071009151702.GA19209@lixom.net>
	<20071009222003.GA21228@kroah.com>
	<alpine.LFD.0.9999.0710100120340.7766@localhost.localdomain>
	<alpine.LFD.0.999.0710091625520.3838@woody.linux-foundation.org>
	<20071010000815.GB7875@lixom.net>
	<20071010101826.186f1f24.sfr@canb.auug.org.au>
	<20071010003824.GA8477@lixom.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson writes:

> Don't allow cpu hotplug on systems lacking XICS interrupt controller,
> since current code is hardcoded for it.
...
> +	for (np = NULL; (np = of_find_node_by_name(np,
> +						   "interrupt-controller"));) {

Looks like for_each_node_by_name would be nicer here.

If you agree, I'll hand-edit your patch to do that and apply it.  Of
course, ultimately we should implement the necessary mpic bits to
support cpu hotplug.

Paul.
