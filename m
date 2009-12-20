Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZLTKrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZLTKrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 05:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbZLTKrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 05:47:16 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:54438 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbZLTKrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 05:47:15 -0500
Message-ID: <4B2E00B1.9010009@msgid.tls.msk.ru>
Date: Sun, 20 Dec 2009 13:47:13 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
       Michael Guntsche <mike@it-loops.com>,
       Oliver Hartkopp <oliver@hartkopp.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: correct size calculation of bzImgae / fix x86
 boot
References: <20091219233457.GA4288@trillian.comsick.at> <20091220084656.GA485@merkur.ravnborg.org> <20091220091138.GA1793@trillian.comsick.at> <20091220100344.GA6614@merkur.ravnborg.org> <20091220102857.GG32739@1wt.eu>
In-Reply-To: <20091220102857.GG32739@1wt.eu>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Sun, Dec 20, 2009 at 11:03:44AM +0100, Sam Ravnborg wrote:
>> We use ... printf \x ... when calculating the size of the
>> compressed kernel.
>> Unfortunately dash built-in printf does not support this notation
>> resulting in a non-bootable kernel.
>>
>> Fix this by always using the external version of printf.
> 
> Do we really want to workaround shells bugs ? I mean, either

There's no bugs in dash, as far as I can see.  According to
POSIX, a) echo does not need to interpret _any_ escape sequences
at all, and b) printf is not required to interpret \x sequences.
Ref:

http://www.opengroup.org/onlinepubs/000095399/utilities/echo.html
...
  string
    A string to be written to standard output. If the first operand is -n,
    or if any of the operands contain a backslash ( '\' ) character,
   the results are implementation-defined.

    [XSI] On XSI-conformant systems, [..] the following character sequences
    shall be recognized on XSI-conformant systems within any of the arguments:

    \a \b \c \f \n \r \t \v \\
    \0num
        Write an 8-bit value that is the zero, one, two, or three-digit octal
        number num.

http://www.opengroup.org/onlinepubs/000095399/utilities/printf.html

 In addition to the escape sequences shown in the Base Definitions volume of IEEE
 Std 1003.1-2001, Chapter 5, File Format Notation ( '\\', '\a', '\b', '\f', '\n',
 '\r', '\t', '\v' ), "\ddd", where ddd is a one, two, or three-digit octal number,
 shall be written as a byte with the numeric value specified by the octal number.

[]
> The more absolute paths we specify, the less portable the
> build system. And if linking /bin/sh to whatever shell works
> but linking it to dash breaks, it's a shell bug.

Yes for absolute paths, and no for dash, see above.

/mjt
