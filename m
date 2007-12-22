Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbXLVVKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbXLVVKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 16:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbXLVVK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 16:10:28 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:58916 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbXLVVK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 16:10:28 -0500
Date: Sat, 22 Dec 2007 14:10:26 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       torvalds@linux-foundation.org
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver opt-in issue
Message-ID: <20071222211026.GT29690@parisc-linux.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <20071222155436.GS29690@parisc-linux.org> <20071222080249.482fab0b@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071222080249.482fab0b@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2007 at 08:02:49AM -0800, Arjan van de Ven wrote:
> even then.. it's technically not correct; you're not supposed to mix access types for the same device..
> Just doing opt-in also allows us to do quirks (forbid access) as well.

I think what this specification means is that you can't mix both _at the
same time_.  ie, doing a type 1 cycle, then before it returns, do an
mmconfig cycle.  We never try to do that because there's a spinlock to
prevent more than one config space access at a time.  It *has* to work
to do them sequentially -- for example, the BIOS may do type1 config
accesses, then the OS may do mmconfig.

I've occasionally wondered if that spinlock needs to get split up, but
for the amount of pain that could ensue, I can't imagine it ever being
worthwhile.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
