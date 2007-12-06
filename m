Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbXLFIQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbXLFIQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 03:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbXLFIQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 03:16:30 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:51288 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbXLFIQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 03:16:30 -0500
Date: Thu, 6 Dec 2007 01:16:28 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: Fix bus resource assignment on 32 bits with 64b resources
Message-ID: <20071206081628.GA15868@parisc-linux.org>
References: <20071205064116.D849BDE10A@ozlabs.org> <1196911347.7033.15.camel@pasglop> <20071206063940.GA16474@kroah.com> <1196927934.7033.39.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196927934.7033.39.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 06:58:54PM +1100, Benjamin Herrenschmidt wrote:
> I was just hoping somebody had a better idea, like a way to add a new
> format specifier to printk without losing gcc type checking :-)

It's been discussed before.  Some of the solutions discussed:

 - Add something like PRI_RES which can be concatenated into a printk.
   Ugly.
 - Patch gcc to allow user-definable types.  I think OpenBSD has a patch
   for this.  Then we have to get that patch propagated to all the
   people who compile the kernel.  Unappetising.
 - Disable gcc's printk checking, teach sparse to typecheck printk.
   Most people don't run sparse yet.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
