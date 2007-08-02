Return-Path: <linux-kernel-owner+w=401wt.eu-S1761303AbXHBUMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303AbXHBUMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759782AbXHBUMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:12:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759619AbXHBUMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:12:14 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Aug 2007 23:06:44 +0200
In-Reply-To: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
Message-ID: <p73vebxmysb.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Hi
> 
> I've run across the following gcc "feature":
> 
> 	char c[4] = "01234";
> 
> gcc emits a nice warning
> 
> warning: initializer-string for array of chars is too long
> 
> But do a
> 
> 	char c[4] = "0123";
> and - a wonder - no warning. 

It's required by the C standard.

6.7.8.14 of C99:
``
An array of character type may be initialized by a character string literal, optionally
enclosed in braces. Successive characters of the character string literal (including the
terminating null character if there is room or if the array is of unknown size) initialize the
elements of the array.
''

Note the "if there is room".

I believe the rationale is that it still allows to conveniently initialize 
non zero terminated strings.

-Andi
