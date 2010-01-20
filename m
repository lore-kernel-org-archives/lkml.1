Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164Ab0ATTDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab0ATTDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108Ab0ATTDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:03:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49367 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab0ATTDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:03:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: Generic DMA - BUG_ON
Date: Wed, 20 Jan 2010 20:03:12 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       michal.simek@petalogix.com, linux-arch@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, mingo@elte.hu
References: <1263982111-24123-1-git-send-email-monstr@monstr.eu> <20100120110031.GD8665@amd.com> <4B56E66C.50004@monstr.eu>
In-Reply-To: <4B56E66C.50004@monstr.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001202003.13353.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/KhaxWLBhagVoFbNIOpAeHsxk32gLoxr9ySM7
 MEgxVnrIWuK6kaRu31VD7f166Kfbcln7s6ssxgkLtvk+Ydk647
 qcY39wCWgevuvI4QRb0Yg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 January 2010, Michal Simek wrote:
> Joerg Roedel wrote:
> > On Wed, Jan 20, 2010 at 10:53:50AM +0000, Russell King wrote:
> >> and ops is NULL, then this code will oops; you will get a full register
> >> dump and backtrace.  You can use this information along with markup_oops.pl
> >> to find out where the problem is.
> > 
> > You can't rely on the oops if the code runs in process context. The
> > process may have address 0 mapped which would result in a security hole.
> > We had two of these bugs last year.
> 
> That's the same problem which I had some days ago and Microblaze misses 
> valuable backtrace (because we don't have FP or constant frame size).

You can do what x86 does and just print anything in the stack that looks
like part of a kernel function.

> > But I don't see any point in checking for dma_ops != NULL too. Any
> > developer would mention such a bug long before init is started.
> 
> I agree that checking adds extra cycles to every dma-api call.
> 
> I like as wrote Russel to check if ops exists or not.

If you are worried about the overhead, you could just add the BUG_ON
to the map calls but not to unmap and sync, which are rather unlikely
(and incorrect) to be called before a map.

	Arnd
