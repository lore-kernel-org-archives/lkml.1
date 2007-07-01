Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbXGAE0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbXGAE0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 00:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbXGAE0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 00:26:40 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4254 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbXGAE0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 00:26:39 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 30 Jun 2007 21:25:08 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Andy Isaacson <adi@hexapodia.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer
 madness
In-Reply-To: <B04FEDC9-A315-4374-843E-DD81E52C5772@mac.com>
Message-ID: <Pine.LNX.4.64.0706302116200.5375@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0>
 <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com> <20070629193954.GL9157@hexapodia.org>
 <Pine.LNX.4.64.0706291306220.31176@alien.or.mcafeemobile.com>
 <D65DCB84-F812-4C3B-8E68-EACA0CA8A0C0@mac.com>
 <Pine.LNX.4.64.0706291711320.31176@alien.or.mcafeemobile.com>
 <8F40BE4A-BD38-4C3F-B77D-35661E84C553@mac.com>
 <Pine.LNX.4.64.0706301652050.2957@alien.or.mcafeemobile.com>
 <B04FEDC9-A315-4374-843E-DD81E52C5772@mac.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jun 2007, Kyle Moffett wrote:

> On Jun 30, 2007, at 19:57:18, Davide Libenzi wrote:
> > On Sat, 30 Jun 2007, Kyle Moffett wrote:
> > > Very simple case:  SELinux is turned on, an s9 (IE: TOP_SECRET) process
> > > calls free(), and an s3 (IE: UNCLASSIFIED) process calls malloc(), getting
> > > the data from the TOP_SECRET process.
> > 
> > Note that you use *s3* and *s9*. Those will be two different context
> > cookies.  SeLinux will have its own way to set the cookie in the mm_struct,
> > to *s3* in one case, and to *s9* in the other case. This will make things so
> > that they'll never see each other pages.
> 
> Except s3 and s9 aren't complete cookies.  A complete label might be:
> "system_u:system_r:apache2_t:s3" for an unclassified apache web-server
> process, or "kmoffett_u:secadmin_r:usershell_t:s9" for me logged in with a
> top-secret label in my security-administrator role.  That's why you'd need to
> call an LSM hook to get a unique identifier, as the LSM would actually need to
> allocate identifiers for equivalence classes.  Secondly, processes may change
> labels as they run, so you couldn't just call it once and cache the result,
> you would need to call it for every freed page (or every re-use of a page).

It does not matter what the UID contain and how it is generated. The focus 
now should be to verify that different UIDs do not see other UIDs pages. 
Once that is verified to be true, and if SeLinux actually wants to use 
it, we'll find a way so that the other 99% of Linux users won't pay the 
price of the abstraction needed to accomplish what they need for this to 
work for them. Ok?



- Davide


