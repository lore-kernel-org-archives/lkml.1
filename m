Return-Path: <linux-kernel-owner+w=401wt.eu-S2992985AbXDRXru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992985AbXDRXru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 19:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993002AbXDRXru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 19:47:50 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:49468 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992985AbXDRXrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 19:47:49 -0400
X-Originating-Ip: 24.6.145.253
Date: Wed, 18 Apr 2007 19:45:42 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Len Brown <lenb@kernel.org>
cc: davej@codemonkey.org.uk, Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Kill off legacy power management stuff.
In-Reply-To: <200704181723.16241.lenb@kernel.org>
Message-ID: <Pine.LNX.4.64.0704181940260.5400@localhost.localdomain>
References: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6>
 <200704181524.16980.lenb@kernel.org> <Pine.LNX.4.64.0704181615510.18034@localhost.localdomain>
 <200704181723.16241.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-14.854, required 5, ALL_TRUSTED -1.80, BAYES_00 -15.00,
	INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_NJABL_DUL 1.95,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, Len Brown wrote:

> On Wednesday 18 April 2007 16:23, Robert P. J. Day wrote:

> > ok, i get it now and -- correct me if i'm wrong -- all my legacy PM
> > removal patch was doing was exposing a design boo-boo in which
> > APM/ACPI contention was being handled by a macro in a subsystem even
> > older than either of them, right?
>
> yeah, it didn't start out that way, the bug was added when the
> CONFIG_PM_LEGACY #define was added.
>
> > so all that needs to be done is add back in a contention solution
> > of some kind that doesn't rely on that ancient system, yes?
>
> Yes, it is a matter of making the variable not go away when the
> #define goes away.
>
> > as for that thinkpad t30 situation, well, that's just borked, and
> > should be fixed.
>
> yes, the actual failure is that APM mode on the T30 hangs -- and
> that is independent of the issue at hand.  However, there could be
> other failures on other machines when both APM and ACPI think they
> are active.

at this point, i think the proper approach is to locate and remove all
dependencies on the legacy PM code, which includes making sure there's
a reliable contention mechanism for APM and ACPI that doesn't need
anything out of the legacy code or header files.  once that's done,
the legacy deletion itself should be trivial.

the obvious place for the contention stuff is, i would think,
include/linux/pm.h, yes?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
