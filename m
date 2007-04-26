Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbXDZTsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbXDZTsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbXDZTsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:48:39 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2219 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbXDZTsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:48:37 -0400
Message-ID: <46310216.2070608@shadowen.org>
Date: Thu, 26 Apr 2007 20:48:38 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 -- PPC link failure
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <4630A662.8090502@shadowen.org> <4630ABF2.1040305@shadowen.org> <4630EBFA.9000207@shadowen.org> <Pine.LNX.4.64.0704261123080.3560@schroedinger.engr.sgi.com> <4630F203.7020005@shadowen.org> <Pine.LNX.4.64.0704261210430.7441@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704261210430.7441@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 26 Apr 2007, Andy Whitcroft wrote:
> 
>>> But then how important is gcc 3.3 support?
>> Well we say 3.2 is the minimum.  If we simply return(NULL) or BUG() in
> 
> Oh before I forget
> 
> Gcc 3.3 works just fine on other platforms like i386. This is more likely 
> a platform issue. If we disable it then only for <= gcc 3.3 on ppc. If 
> problems crop up with other platforms then we can expand on it.

I was thinking that it would be nasty to have a set of platform
specific, compiler specific ifdefs in here.  I was more thinking of just
making this a BUG for all platforms.  This does result in slightly later
detection but this is a constant mode only, so any bad use of kmalloc()
would be picked up on first boot in testing always.

I think that would be sufficient and safe even against the worst
optimiser (none).  Plus much less horrible to look at?

-apw
