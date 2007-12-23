Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbXLWFEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbXLWFEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 00:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbXLWFEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 00:04:46 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:48570 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbXLWFEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 00:04:46 -0500
Message-ID: <476DEC66.9050701@garzik.org>
Date: Sun, 23 Dec 2007 00:04:38 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DE07A.4000204@garzik.org> <476DE19F.5040702@garzik.org> <alpine.LFD.0.9999.0712222040520.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712222040520.21557@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> I want to limit that downside. Right now, the easiest way to limit it 
> seems to be to say that those (very very few) drivers that actually care 
> could enable it. That way, we automatically limit it to only those 
> machines that have hardware that cares.

Then let's do it right:  disable mmconfig by default on x86, and enable 
it when passed "pci=mmconfig".

For the rare -- you and I agree its very rare -- case where it is 
REQUIRED, the user can pass pci=mmconfig as instructed by driver 
documentation somewhere.

Let's not bend over backwards and introduce an API for these 
presently-theoretical cases.  Given the complete lack of hw vendor 
testing and potential to confuse userspace, the two choices for a 
computer should be "mmconfig off" or "mmconfig on."

Kernel hackers developing drivers and code for new machines will know 
enough to pass pci=mmconfig if they NEED it.  That practice will only 
become annoying when x86 hardware actually starts to NEED extended 
config space -- at which future time we can revisit, as you describe.


> And yes, if you want the capability following to notice automatically when 
> capabilities really do go into the 0x100+ range, that's fine. I suspect 

Yes, we /must/ do this checking, if we don't already.

	Jeff


