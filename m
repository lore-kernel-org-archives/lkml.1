Return-Path: <linux-kernel-owner+w=401wt.eu-S1763654AbXFGPbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763654AbXFGPbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbXFGPbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:31:22 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:58655 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761468AbXFGPbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:31:22 -0400
Message-ID: <466824C6.60100@s5r6.in-berlin.de>
Date: Thu, 07 Jun 2007 17:31:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why is it called "asm-generic/atomic.h"?
References: <Pine.LNX.4.64.0706070822590.17588@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0706070822590.17588@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>   i'm just curious -- why does that particular header file have that
> name?  its opening comment reads:
> 
>  * Allows to provide arch independent atomic definitions without the need to
>  * edit all arch specific atomic.h files.
> 
> but that's *not* what that header file does.

The file name is correct, and the comment is correct too.  It indeed
_allows_ to define architecture-independent operations on atomic types,
and it currently does so for atomic_long_t.  There is no need to do so
for atomic_t, because all architectures already had their own set of
atomic_t operations when asm-generic/atomic.h was added.  (And I presume
they varied too much to justify an additional generic implementation
plus #ifndef HAVE_ARCH_SOMETHING games.)

PS:  The atomic_long_t operations currently don't need to be protected
by #ifndef HAVE_ARCH_SOMETHING and won't need to be in foreseeable
future, therefore they don't have this protection.
-- 
Stefan Richter
-=====-=-=== -==- --===
http://arcgraph.de/sr/
