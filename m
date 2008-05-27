Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbYE0FoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbYE0FoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 01:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYE0Fn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 01:43:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33944 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYE0Fnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 01:43:55 -0400
Subject: Re: Linux 2.6.26-rc4
From: David Woodhouse <dwmw2@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
In-Reply-To: <20080526172519.10d944ab@infradead.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
	 <483B2A9B.4050007@krogh.cc>
	 <alpine.LFD.1.10.0805261428140.2958@woody.linux-foundation.org>
	 <20080526172519.10d944ab@infradead.org>
Content-Type: text/plain
Date: Tue, 27 May 2008 06:43:51 +0100
Message-Id: <1211867031.10205.13.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-26 at 17:25 -0700, Arjan van de Ven wrote:
> btw this guy has shown up on kerneloops.org a lot: 
> http://www.kerneloops.org/searchweek.php?search=__ioremap_caller
> where it's trying to map memory as uncachable, which is.. well nasty
> (it seems to map not just the piece it needs, but more, and then turns
> that "more" uncachable, even if the kernel is using it for "normal"
> things)

The driver needs that 'more' to reach the lock registers for the flash
chip. If it's being used for other things, shouldn't the
request_region() fail?

On a vaguely related note, there's a lot to be said for _not_ using the
standard PCI driver setup on the BIOS flash drivers, and going back to
having them manually loaded rather than being automatically loaded
whenever the appropriate southbridge is present.

It would be nicer if the only people who have write access to their BIOS
flash are the ones who _really_ wanted it.

-- 
dwmw2

