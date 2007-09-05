Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbXIENWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbXIENWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 09:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbXIENWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 09:22:25 -0400
Received: from 207.47.60.147.static.nextweb.net ([207.47.60.147]:31415 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbXIENWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 09:22:24 -0400
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Sep 2007 09:22:24 EDT
Subject: Re: New x86-Setup code breaks HVM-XEN boot
From: Ian Campbell <Ian.Campbell@XenSource.com>
To: Christian Ehrhardt <lk@c--e.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com
In-Reply-To: <20070831075434.GF20195@genua.de>
References: <20070830141528.GA307@lisa.in-ulm.de>
	 <46D714A9.4060103@goop.org>  <20070831075434.GF20195@genua.de>
Content-Type: text/plain
Date: Wed, 05 Sep 2007 14:06:05 +0100
Message-Id: <1188997566.11625.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Sep 2007 13:06:09.0125 (UTC) FILETIME=[86B58950:01C7EFBD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-31 at 09:54 +0200, Christian Ehrhardt wrote:
> (XEN) (GUEST: 353) Detected Xen v3.0.3-1 

I was unable to reproduce this problem on Xen 3.1.0 although I can't
immediately see a particular changeset which obviously fixed it. There
have been plenty of fixes to the emulator since 3.0.3 though so it's
worth trying a newer version.

In a later mail:
> The problem is with the lgdt instruction. Apparently XEN does not keep
> the contents of the 48-bit gdt_48 data structure that is passed to
> lgdt in the XEN machine state. Instead it appears to save the
> _address_ of the 48-bit descriptor somewhere. Unfortunately this data
> happens to reside on the stack and is probably no longer availiable at
> the time of the actual protected mode jump.

The emulation of lgdt (in tools/firmware/vmxassist/vm86.c) looks sane
enough on first glance (i.e. it saves the base and length not the
pointer) although it isn't an area of the code I'm particularly familiar
with.

Ian.


