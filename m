Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbZA2Oh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbZA2Oh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbZA2Ohp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:37:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:32966 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbZA2Ohp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:37:45 -0500
Date: Thu, 29 Jan 2009 14:37:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH D 11/11] Fix omap1 clock issues
Message-ID: <20090129143733.GB18233@n2100.arm.linux.org.uk>
References: <20090128191638.16688.33452.stgit@localhost.localdomain> <20090128191844.16688.39372.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128191844.16688.39372.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 12:18:48PM -0700, Paul Walmsley wrote:
> From: Tony Lindgren <tony@atomide.com>
> 
> This fixes booting, and is a step toward fixing things properly:
> 
> - Make enable_reg u32 instead of u16

No, you're passing this to __raw_read/write, so it needs to be
void __iomem *, not u32.  If there's another patch doing that it
needs to be combined with this one.  The miniscule details of
fixes upon fixes aren't interesting for submission purposes, and
just adds extra unnecessary review load for upstream people.

Ditto for anything else which is passed to __raw_read/write*.
