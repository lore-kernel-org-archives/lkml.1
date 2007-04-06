Return-Path: <linux-kernel-owner+w=401wt.eu-S1767457AbXDFAeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767457AbXDFAeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767458AbXDFAeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:34:05 -0400
Received: from gw.goop.org ([64.81.55.164]:60772 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767457AbXDFAeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:34:04 -0400
Message-ID: <46159555.4020706@goop.org>
Date: Thu, 05 Apr 2007 17:33:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Bugfix for VMI paravirt ops
References: <46158674.5090709@vmware.com> <200704060154.41574.ak@suse.de> <46158DE1.4050508@vmware.com> <46158F8E.1050807@goop.org> <46158FBE.3090105@vmware.com> <461590EA.10605@goop.org> <4615924E.8020009@vmware.com>
In-Reply-To: <4615924E.8020009@vmware.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> So the clean fix for this is still even further out.  I don't think I
> want to hook kmap/unmap as paravirt-ops.

Yes, it seems like overkill.

How about something like adding PARAVIRT_LAZY_FLUSH as an argument to
set_lazy_mode?  It would be valid to use at any time, and it would flush
any pending work while still remaining in whatever lazy mode its
currently in.  That way kmap_atomic can flush anything pending without
having to muck around with the current lazy state.

    J
