Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbXDFAPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbXDFAPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbXDFAPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:15:15 -0400
Received: from gw.goop.org ([64.81.55.164]:39808 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbXDFAPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:15:11 -0400
Message-ID: <461590EA.10605@goop.org>
Date: Thu, 05 Apr 2007 17:14:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Bugfix for VMI paravirt ops
References: <46158674.5090709@vmware.com> <200704060154.41574.ak@suse.de> <46158DE1.4050508@vmware.com> <46158F8E.1050807@goop.org> <46158FBE.3090105@vmware.com>
In-Reply-To: <46158FBE.3090105@vmware.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> No, they are totally dependent.  The reason interrupts are disabled is
> to stop kmap_atomic in interrupt handlers.  With the kmap_atomic_pte
> changes, the whole interrupt disable jibberish goes away. 

But kmap_atomic_pte is a special case of kmap_atomic for ptes. 
Interrupt routines can still use plain kmap_atomic for bouncebuffers and
so on.

A more general patch would be to make kmap/unmap_atomic pv_ops, and then
they can all be rolled together.  I.e: check the type to see if special
pte handling needs to happen, etc.

    J

