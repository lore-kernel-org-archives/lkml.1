Return-Path: <linux-kernel-owner+w=401wt.eu-S932861AbXHAOJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbXHAOJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932146AbXHAOJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:09:31 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1330 "EHLO Perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107AbXHAOJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:09:30 -0400
Subject: Re: [PATCH] - Remove current defines and uses of pr_err, add
	pr_emerg, pr_alert, pr_crit, pr_err, pr_warn, pr_notice to
	include/linux/kernel.h
From: Joe Perches <joe@perches.com>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
In-Reply-To: <46B04348.1060907@kernel.sg>
References: <1185941363.14777.34.camel@localhost>
	 <46B04348.1060907@kernel.sg>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 07:09:26 -0700
Message-Id: <1185977366.14777.44.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 16:24 +0800, Eugene Teo wrote:
> But why are you replacing the existing pr_*() with printk(KERN_*?

Order of compilation if bisected?

The idea is to eventually convert all single line
printk(KERN_<level> fmt "\n",...) to pr_<level>
tree wide.  This leaves only the multiline
printk(foo); printk(bar "\n") code which might
possibly be fixed to eliminate messages that are
interleaved by thread/cpu.

