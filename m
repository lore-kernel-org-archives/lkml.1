Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbXHBUmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbXHBUmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbXHBUl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:41:59 -0400
Received: from mail.gmx.net ([213.165.64.20]:39421 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751722AbXHBUl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:41:58 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX195UJhlgzV5kJZEuiQKtMEhqgbAsI4LV1ckNCdNZ1
	q20VM2QWN3B26w
Date: Thu, 2 Aug 2007 22:36:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
In-Reply-To: <p73vebxmysb.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.60.0708022231160.6774@poirot.grange>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
 <p73vebxmysb.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, Andi Kleen wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > 	char c[4] = "0123";
> > and - a wonder - no warning. 
> 
> It's required by the C standard.
> 
> 6.7.8.14 of C99:
> ``
> An array of character type may be initialized by a character string literal, optionally
> enclosed in braces. Successive characters of the character string literal (including the
> terminating null character if there is room or if the array is of unknown size) initialize the
> elements of the array.
> ''
> 
> Note the "if there is room".
> 
> I believe the rationale is that it still allows to conveniently initialize 
> non zero terminated strings.

Right, I accept that it will compile, but I don't understand why "01234" 
produces a warning and "0123" doesn't? Don't think C99 says anything about 
that. And, AFAIU, using structs with fixed-size char array we more or less 
rely on the compiler warning us if anyone initializes it with too long a 
string.

Also interesting, that with

	char c[4] = "012345";

the compiler warns, but actually allocates a 6-byte long array...

Thanks
Guennadi
---
Guennadi Liakhovetski
