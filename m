Return-Path: <linux-kernel-owner+w=401wt.eu-S1762844AbYA2Fvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762844AbYA2Fvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbYA2FvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:51:14 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:34431
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761614AbYA2FvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:51:11 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24 panics initializing ne2k in mips.
Date: Mon, 28 Jan 2008 23:51:00 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-mips@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <200801280217.38273.rob@landley.net>
In-Reply-To: <200801280217.38273.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801282351.01776.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008 02:17:37 Rob Landley wrote:
> The 2.6.23 kernel built for mips with the attached .config works fine for
> me under qemu (both big endian and little endian), but a 2.6.24 mips kernel
> segfaults initializing the ne2k driver (again when run under qemu).
>
> I've traced it to this commit:
>
>   http://kernel.org/hg/linux-2.6/rev/74258
>
> Version 74257 works, 74258 does not.

For the git users in the audience, that's commit 
30e748a507919a41f9eb4d10b4954f453325a37d

I just confirmed that:

A) today's -git still exhibits this bug.

B) Backing out the above irq-twiddling patch makes it stop exhibiting the bug 
for me.  (Boots to a shell prompt, it can use the network, etc.)

So that patch is definitely the trigger for the panic, and reverting the patch 
is one way to fix it.  (And probably the best way to make it work for 
2.6.24.1.)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
