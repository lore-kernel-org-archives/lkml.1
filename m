Return-Path: <linux-kernel-owner+w=401wt.eu-S1767712AbXCJBhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767712AbXCJBhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 20:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767713AbXCJBhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 20:37:38 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:30238 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767712AbXCJBhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 20:37:37 -0500
Date: Fri, 9 Mar 2007 17:37:36 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Kees Cook <kees@outflux.net>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: maps protection
Message-ID: <20070310013736.GA18877@hexapodia.org>
References: <20070307012234.GN9621@outflux.net> <20070306175609.267bd7a9.akpm@linux-foundation.org> <20070307021335.GR9621@outflux.net> <20070306185942.585e7cd1.akpm@linux-foundation.org> <20070307031429.GU9621@outflux.net> <1173241331.3236.10.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173241331.3236.10.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.2i
X-PGP-Fingerprint: 48 01 21 E2 D4 E4 68 D1  B8 DF 39 B2 AF A3 16 B9
X-PGP-Key-URL: http://web.hexapodia.org/~adi/pgp.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 08:22:11PM -0800, Arjan van de Ven wrote:
> > How about using a reduced check, as is done for fd and environ?  This 
> > would allow root-running system monitors to still do their job.  
> > Effectively, this changes the test from "is ptracing" to just "can 
> > ptrace".
> > 
> > If this still isn't considered safe, I'll add the maps_protect file...
> 
> btw I consider it an information leak that any user can see which
> files/libraries any other user and root has mmap'd. (and with glibc's
> stdio mmap feature that goes even beyond direct mmap to fopen()'d).
> 
> If root or some other user wants to watch
> hillary-vs-obama-in-the-mud.avi, no other user has ANY business even
> seeing that. So at minimum it's a privacy issue showing the filenames...

Sure, I would be fine with making /proc/<pid>/maps mode 0400 (so long as
root can still read it).  But please don't take away my ability to debug
applications using pmap(1).  It's so incredibly useful to be able to say
"ah, look, he mapped nss_nis.so rather than nss_nisplus.so".

-andy
