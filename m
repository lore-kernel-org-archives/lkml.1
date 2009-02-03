Return-Path: <linux-kernel-owner+w=401wt.eu-S1752846AbZBCBdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbZBCBdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbZBCBdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:33:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbZBCBdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:33:18 -0500
Date: Mon, 2 Feb 2009 17:32:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <1233623525.18767.151.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0902021729510.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>  <200902030045.19416.rjw@sisk.pl>  <alpine.LFD.2.00.0902021551050.3247@localhost.localdomain>  <200902030115.32659.rjw@sisk.pl>  <alpine.LFD.2.00.0902021622350.3247@localhost.localdomain>
 <1233623525.18767.151.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Benjamin Herrenschmidt wrote:
> 
> Anyway, my proposed radeonfb patch is at:
> 
>  http://bugzilla.kernel.org/attachment.cgi?id=20085
> 
> I'll look at cleaning up atyfb and aty128fb later today if needed.

Ok.

Note how the PCI layer (currently) only saves the low _16_ dwords of 
config space (64 bytes). The radeonfb code that did it by hand saved the 
whole 64 dwords (256 bytes). It _probably_ doesn't matter, but..

The reason the PCI layer only does 64 bytes is that that was the really 
old PCI config space model - the rest was undefined and apparently a few 
cards reportedly even crashed when accessing it (but who knows, that may 
be urban folklore).

But if that patch works for you, it's clearly already better than _not_ 
applying the patch, so..

			Linus
