Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbYBIPjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbYBIPjF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYBIPix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:38:53 -0500
Received: from www.tglx.de ([62.245.132.106]:56611 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbYBIPiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:38:52 -0500
Date: Sat, 9 Feb 2008 16:38:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/5] CPA: Make advised protection check truly
 advisory
In-Reply-To: <20080208163614.DF4FC1B41AA@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0802091602260.3145@apollo.tec.linutronix.de>
References: <20080208536.837219990@suse.de> <20080208163614.DF4FC1B41AA@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, Andi Kleen wrote:

> 
> Only force RO in the advisory protection checks when all pages in the 
> range are RO. Previously it would trigger when any page in the range
> was ro.
> 
> I believe this will make try_preserve_large_page much safer to use.

It might be quite useful to know it for sure.

Thinking about the whole set of changes, you are right, that the
current check for the first page only is not correct, but I don't see
how your changes make it more correct.

The correct way to fix this is to check, whether all the small pages,
which fit in the range of the large page, which we want to preserve,
have the same resulting pgprot flags.

Thanks,
	tglx
