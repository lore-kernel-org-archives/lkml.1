Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbZLTNKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbZLTNKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 08:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbZLTNKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 08:10:16 -0500
Received: from 1wt.eu ([62.212.114.60]:52833 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691AbZLTNKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 08:10:14 -0500
Date: Sun, 20 Dec 2009 14:09:52 +0100
From: Willy Tarreau <w@1wt.eu>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
       Michael Guntsche <mike@it-loops.com>,
       Oliver Hartkopp <oliver@hartkopp.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: correct size calculation of bzImgae / fix x86 boot
Message-ID: <20091220130952.GD9719@1wt.eu>
References: <20091219233457.GA4288@trillian.comsick.at> <20091220084656.GA485@merkur.ravnborg.org> <20091220091138.GA1793@trillian.comsick.at> <20091220100344.GA6614@merkur.ravnborg.org> <20091220102857.GG32739@1wt.eu> <4B2E00B1.9010009@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2E00B1.9010009@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 01:47:13PM +0300, Michael Tokarev wrote:
> Willy Tarreau wrote:
> > On Sun, Dec 20, 2009 at 11:03:44AM +0100, Sam Ravnborg wrote:
> >> We use ... printf \x ... when calculating the size of the
> >> compressed kernel.
> >> Unfortunately dash built-in printf does not support this notation
> >> resulting in a non-bootable kernel.
> >>
> >> Fix this by always using the external version of printf.
> > 
> > Do we really want to workaround shells bugs ? I mean, either
> 
> There's no bugs in dash, as far as I can see.  According to
> POSIX, a) echo does not need to interpret _any_ escape sequences
> at all, and b) printf is not required to interpret \x sequences.

Interesting.

> Ref:
> 
> http://www.opengroup.org/onlinepubs/000095399/utilities/echo.html
> ...
>   string
>     A string to be written to standard output. If the first operand is -n,
>     or if any of the operands contain a backslash ( '\' ) character,
>    the results are implementation-defined.
> 
>     [XSI] On XSI-conformant systems, [..] the following character sequences
>     shall be recognized on XSI-conformant systems within any of the arguments:
> 
>     \a \b \c \f \n \r \t \v \\
>     \0num
>         Write an 8-bit value that is the zero, one, two, or three-digit octal
>         number num.
> 
> http://www.opengroup.org/onlinepubs/000095399/utilities/printf.html
> 
>  In addition to the escape sequences shown in the Base Definitions volume of IEEE
>  Std 1003.1-2001, Chapter 5, File Format Notation ( '\\', '\a', '\b', '\f', '\n',
>  '\r', '\t', '\v' ), "\ddd", where ddd is a one, two, or three-digit octal number,
>  shall be written as a byte with the numeric value specified by the octal number.

OK so the bug will not be fixed by calling /usr/bin/printf. It
will still work by pure luck when a the proper printf utility
will be there, but not when we use a posix-compliant one. The
proper fix then consists in writing octal chars in the form
of "\ddd" instead of "\xhh". And if dash is posix-compliant,
no need for the absolute path.

Willy

