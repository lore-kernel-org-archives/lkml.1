Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbXJJSJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbXJJSJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 14:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbXJJSJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 14:09:06 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:45513 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbXJJSJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 14:09:04 -0400
Message-ID: <470D1535.6030708@freedesktop.org>
Date: Wed, 10 Oct 2007 11:08:53 -0700
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Morten Welinder <mwelinder@gmail.com>
CC: Alexey Dobriyan <adobriyan@sw.ru>, Al Viro <viro@ftp.linux.org.uk>,
       linux-kernel@vger.kernel.org, davej@codemonkey.org.uk,
       Pierre Ossman <drzeus@drzeus.cx>, akpm@osdl.org,
       linux-sparse@vger.kernel.org
Subject: Re: idio{,ma}tic typos (was Re: + fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch
 added to -mm tree)
References: <20071010104540.GA6366@localhost.sw.ru> <118833cc0710100635x205503a2peb73d24384538afa@mail.gmail.com>
In-Reply-To: <118833cc0710100635x205503a2peb73d24384538afa@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Morten Welinder wrote:
>> While we're at it, below is somewhat ugly sparse patch for detecting
>> "&& 0x" typos.
> 
> Excellent idea, and there is something to be said about a low-footprint patch
> like that.  However, if you really want to capture this kind of bugs, you would
> need to have some kind "not a boolean" or "bitfield" attribute that
> can propagate.
> For example, you would want
> 
>     if (foo && (BAR | BAZ)) ...;
> 
> with BAR and BAZ being hex constants to produce the same warning.
> 
> Incidentally, it is probably not just hex constants that deserve this treatment:
> octal constants and variations of (1 << cst) are of the same nature.  As well
> as enums defined in such manners.

Sparse has a notion of "integer constant expression" already, which it
uses to validate expressions used for things like bitfield widths or
array sizes.  I could easily have Sparse warn on any use of an integer
constant expression as an operand of || or &&.  However, I can imagine
that that might lead to some false positives when intentionally using
an integer constant expression in a condition and expecting the
compiler to optimize it out at compile time.

- Josh Triplett
