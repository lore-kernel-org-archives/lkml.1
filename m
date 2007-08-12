Return-Path: <linux-kernel-owner+w=401wt.eu-S932850AbXHLI7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbXHLI7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 04:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759198AbXHLI71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 04:59:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758497AbXHLI70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 04:59:26 -0400
Date: Sun, 12 Aug 2007 01:59:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Petr Vandrovec <petr@vandrovec.name>
cc: ak@suse.de, discuss@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix triplefault on x86-64 bootup
In-Reply-To: <alpine.LFD.0.999.0708120140160.30176@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0708120151150.30176@woody.linux-foundation.org>
References: <20070812081252.GA23309@vana.vc.cvut.cz>
 <alpine.LFD.0.999.0708120140160.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 12 Aug 2007, Linus Torvalds wrote:
> 
> Hmm. Patch looks ok, I just wonder what started triggering this for you?

Oh. It's the "Make patching more robust" commit.

"Robust" my ass.

We used to just copy the replacement in one go (works fine, since it just 
overwrote the two first bytes), and then "nop_out()" the rest (works fine, 
since it didn't matter for memcpy).

That whole commit looks a bit dubious. It also adds a 254-byte stack 
usage (anything actually even close to that big?). Gaah.

		Linus
