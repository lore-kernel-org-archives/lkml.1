Return-Path: <linux-kernel-owner+w=401wt.eu-S933727AbXG0BSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727AbXG0BSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 21:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760221AbXG0BSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 21:18:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58383 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758431AbXG0BSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 21:18:15 -0400
Date: Fri, 27 Jul 2007 02:18:13 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH] ia64: fix a few section mismatch warnings
Message-ID: <20070727011813.GQ27237@ftp.linux.org.uk>
References: <20070726210141.GA7266@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726210141.GA7266@uranus.ravnborg.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 11:01:41PM +0200, Sam Ravnborg wrote:
  
> +static void *__init_refok alloc_rte(unsigned long size)
> +{
> +	return alloc_bootmem(size);
> +}

That makes no sense at all.  If we ever call that after freeing initmem,
we are screwed, period.  Sounds like __init fodder.
