Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYFYVQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYFYVQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 17:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYFYVQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 17:16:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762AbYFYVQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 17:16:34 -0400
Date: Wed, 25 Jun 2008 14:16:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: bjorn.helgaas@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PNP: have quirk_system_pci_resources() include io
 resources.
Message-Id: <20080625141621.28639b58.akpm@linux-foundation.org>
In-Reply-To: <4862873C.3070507@keyaccess.nl>
References: <4862873C.3070507@keyaccess.nl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008 19:58:20 +0200
Rene Herman <rene.herman@keyaccess.nl> wrote:

> +			unsigned int type;
> +
> +			type = pci_resource_flags(pdev, i) &
> +					(IORESOURCE_IO | IORESOURCE_MEM);

pci_resource_flags() returns an unsigned long.

But I think you're right and resource.flags is wrong.  Because there's
no way in which we'll ever be able to use bits 32-63 of that field
anyway.

I suppose that Someone(tm) should convert resource.flags to a u32 or
something.  Minor issue.

