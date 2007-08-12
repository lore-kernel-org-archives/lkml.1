Return-Path: <linux-kernel-owner+w=401wt.eu-S934013AbXHLKDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013AbXHLKDy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 06:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764038AbXHLKDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 06:03:46 -0400
Received: from ns2.suse.de ([195.135.220.15]:49153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763306AbXHLKDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 06:03:45 -0400
From: Andi Kleen <ak@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Fix triplefault on x86-64 bootup
Date: Sun, 12 Aug 2007 12:01:48 +0200
User-Agent: KMail/1.9.1
Cc: Petr Vandrovec <petr@vandrovec.name>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org
References: <20070812081252.GA23309@vana.vc.cvut.cz> <alpine.LFD.0.999.0708120140160.30176@woody.linux-foundation.org> <alpine.LFD.0.999.0708120151150.30176@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708120151150.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708121201.48383.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 August 2007 10:59, Linus Torvalds wrote:
> On Sun, 12 Aug 2007, Linus Torvalds wrote:
> > Hmm. Patch looks ok, I just wonder what started triggering this for you?
>
> Oh. It's the "Make patching more robust" commit.

No it should have been the earlier text_poke change which first
started using mempcy in that path.

> "Robust" my ass.
>
> We used to just copy the replacement in one go (works fine, since it just
> overwrote the two first bytes), and then "nop_out()" the rest (works fine,
> since it didn't matter for memcpy).
>
> That whole commit looks a bit dubious. It also adds a 254-byte stack
> usage (anything actually even close to that big?). Gaah.

The x86-64 copy_user copies the whole function as alternative
and it is over 200 bytes.
The original patch had a smaller buffer and cause x86-64 to BUG
at boot

-Andi


