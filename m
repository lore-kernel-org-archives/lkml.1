Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbYGUK1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbYGUK1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 06:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145AbYGUK0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 06:26:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:40039 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbYGUK0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 06:26:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=GZyc/c7KuZifdxXrE57zOn9kL6VP23JSx38DuGalK4xv1joAOZtJ6+lkbZJmK8oFH3
         xNfj8tfPZCZp3D4MtusBwvmyhx3MqRB4koX5ymXHSIA8rGCkhftcbKGxcPvj/uO0+UJu
         foTJNaXde2O6VWFtRNXu7t8yfmGvZ1YFvmlAg=
Message-ID: <517f3f820807210326x30ce95dayf18d72ba0ce03588@mail.gmail.com>
Date: Mon, 21 Jul 2008 12:26:49 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Michael Kerrisk" <mtk.manpages@gmail.com>
Subject: Re: math_error.7 draft 3, for review
Cc: aj@novell.com, "Fabian Kreutz" <kreutz@dbs.uni-hannover.de>,
       "Andries Brouwer" <Andries.Brouwer@cwi.nl>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <cfd18e0f0807210314s6556f15bue41b1af46e28f77d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0807160647o776d8523yb2f1ed4f0d946911@mail.gmail.com>
	 <cfd18e0f0807210314s6556f15bue41b1af46e28f77d@mail.gmail.com>
X-Google-Sender-Auth: ae0afa46fadca1c7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ooops -- sorry for the noise.  Wrong list CCed]

On 7/21/08, Michael Kerrisk <mtk.manpages@googlemail.com> wrote:
> Andreas,
>
>  The latest version of the page is below.
>
>  ===
>
>  Hi Andreas,
>
>  (Andries suggested that you probably have the background knowledge to
>  help here.)
>
>  The math man pages in man-pages are in a somewhat sorry state, with
>  respect to the following:
>
>  * Few of the pages properly describe the special cases for Inf, -Inf,
>  NaN arguments (e.g., compare "man 3 log" with the POSIX.1 page "man 3p
>  log").
>
>  * There isn't a clear discussion of error cases, and how to determine
>  if an error occurrred using errno and/or fetestexcept(3).
>
>  I'm planning to fix each of the math man pages to address these
>  issues, and use a new page, math_error.7, as an anchor page referenced
>  by all of the math pages for discussion of how to handle errors.
>
>  Would you be willing to review this new page (below) to see whether it
>  correctly describes the glibc details?  Might you also be willing to
>  look at a sampling of the changed math page pages that I'll make later
>  this week/early next week in order to let me know I'm on the right
>  track in terms of the changes I'm making?
>
>  Cheers,
>
>  Michael
>
>
>  .\" Copyright (c) 2008, Linux Foundation, written by Michael Kerrisk
>  .\"     <mtk.manpages@gmail.com>
>  .\"
>  .\" Permission is granted to make and distribute verbatim copies of this
>  .\" manual provided the copyright notice and this permission notice are
>  .\" preserved on all copies.
>  .\"
>  .\" Permission is granted to copy and distribute modified versions of this
>  .\" manual under the conditions for verbatim copying, provided that the
>  .\" entire resulting derived work is distributed under the terms of a
>  .\" permission notice identical to this one.
>  .\"
>  .\" Since the Linux kernel and libraries are constantly changing, this
>  .\" manual page may be incorrect or out-of-date.  The author(s) assume no
>  .\" responsibility for errors or omissions, or for damages resulting from
>  .\" the use of the information contained herein.  The author(s) may not
>  .\" have taken the same level of care in the production of this manual,
>  .\" which is licensed free of charge, as they might when working
>  .\" professionally.
>  .\"
>  .\" Formatted or processed versions of this manual, if unaccompanied by
>  .\" the source, must acknowledge the copyright and authors of this work.
>  .\"
>  .TH MATH_ERROR 7 2008-07-21 "Linux" "Linux Programmer's Manual"
>  .SH SYNOPSIS
>  .nf
>  .B #include <math.h>
>  .B #include <errno.h>
>  .B #include <fenv.h>
>  .fi
>  .SH NAME
>  math_error \- detecting errors from mathematical functions
>  .SH DESCRIPTION
>  On error, many of the mathematical functions declared in
>  .IR <math.h>
>  return a NaN (not a number).
>  However, rather than looking at the return value
>  (which is not always possible)
>  one can also check whether an error was signaled.
>  There are two signaling mechanisms:
>  the older one sets
>  .IR errno ;
>  the newer one uses the floating-point exception mechanism (the use of
>  .BR feclearexcept (3)
>  and
>  .BR fetestexcept (3),
>  as outlined below)
>  described in
>  .BR fenv (3).
>
>  C99 and POSIX.1-2001 specify a
>  .I math_errhandling
>  identifier,
>  which is supposed to indicate which of these two mechanisms is in use;
>  the standards require that at least one be in use,
>  but permit both to be available.
>  Although glibc does not support this identifier,
>  in practice it supports both mechanisms.
>
>  A portable program that needs to check for an error from a mathematical
>  function should set
>  .I errno
>  to zero, and make the following call
>  .in +4n
>  .nf
>
>  feclearexcept(FE_ALL_EXCEPT);
>
>  .fi
>  .in
>  before calling a mathematical function.
>
>  Upon return from the mathematical function, if
>  .I errno
>  is non-zero, or the following call (see
>  .BR fenv (3))
>  returns non-zero
>  .in +4n
>  .nf
>
>  fetestexcept(FE_INVALID | FE_DIVBYZERO | FE_OVERFLOW |
>              FE_UNDERFLOW);
>
>  .fi
>  .in
>  .\" enum
>  .\" {
>  .\" FE_INVALID = 0x01,
>  .\" __FE_DENORM = 0x02,
>  .\" FE_DIVBYZERO = 0x04,
>  .\" FE_OVERFLOW = 0x08,
>  .\" FE_UNDERFLOW = 0x10,
>  .\" FE_INEXACT = 0x20
>  .\" };
>  then an error occurred in the mathematical function.
>
>  The error conditions that can occur for mathematical functions
>  are described below.
>  .SS Domain Error
>  A
>  .I domain error
>  occurs when a mathematical function is supplied with an argument whose
>  value falls outside the domain for which the function
>  is defined (e.g., giving a negative argument to
>  .BR log (3)).
>  When a domain error occurs,
>  .I errno
>  is set to
>  .BR EDOM ,
>  and an "invalid"
>  .RB ( FE_INVALID )
>  floating-point exception is raised.
>  .SS Pole Error
>  A
>  .I pole error
>  occurs when the mathematical result of a function is an exact infinity
>  (e.g., the logarithm of 0 is negative infinity).
>  When a pole error occurs,
>  the function returns the (signed) value
>  .BR HUGE_VAL ,
>  .BR HUGE_VALF ,
>  or
>  .BR HUGE_VALL ,
>  depending on whether the function result type is
>  .IR double ,
>  .IR float ,
>  or
>  .IR "long double" .
>  The sign of the result is that which is mathematically correct for
>  the function.
>  .I errno
>  is set to
>  .BR ERANGE ,
>  and a "divide-by-zero"
>  .RB ( FE_DIVBYZERO )
>  floating-point exception is raised.
>  .SS Range Error
>  A
>  .I range error
>  occurs when the magnitude of the function result means that it
>  cannot be represented in the result type of the function.
>  The return value of the function depends on whether the range error
>  was an overflow or an underflow.
>
>  A floating result
>  .I overflows
>  if the  result is finite,
>  but is too large to represented in the result type.
>  When an overflow occurs,
>  the function returns the value
>  .BR HUGE_VAL ,
>  .BR HUGE_VALF ,
>  or
>  .BR HUGE_VALL ,
>  depending on whether the function result type is
>  .IR double ,
>  .IR float ,
>  or
>  .IR "long double" .
>  .I errno
>  is set to
>  .BR ERANGE ,
>  and an "overflow"
>  .RB ( FE_OVERFLOW )
>  floating-point exception is raised.
>
>  A floating result
>  .I underflows
>  if the result is too small to be represented in the result type.
>  If an underflow occurs,
>  a mathematical function typically returns 0.0
>  (C99 says a function shall return "an implementation-defined value
>  whose magnitude is no greater than the smallest normalized
>  positive number in the specified type").
>  .\" FIXME(mtk) POSIX.1 says "may" for the following two cases; need to
>  .\" investigate this further for specific functions.
>  .I errno
>  may be set to
>  .BR ERANGE ,
>  and an "overflow"
>  .RB ( FE_UNDERFLOW )
>  floating-point exception may be raised.
>
>  Some functions deliver a range error if the supplied argument value,
>  or the correct function result, would be
>  .IR subnormal .
>  A subnormal value is one that is non-zero,
>  but with a magnitude that is so small that
>  it can't be presented in normalized form
>  (i.e., with a 1 in the most significant bit of the significand).
>  The representation of a subnormal number will contain one
>  or more leading zeros in the significand.
>  .SH NOTES
>  The
>  .I math_errhandling
>  identifier specified by C99 and POSIX.1-2001 is not supported.
>  .\" See CONFORMANCE in the glibc 2.8 (and earlier) source.
>
>  To avoid the complexities of using
>  .I errno
>  and
>  .BR fetestexcept (3)
>  for error checking,
>  it is often advised that one should instead check for bad argument
>  values before each call.
>  .\" http://www.securecoding.cert.org/confluence/display/seccode/FLP32-C.+Prevent+or+detect+domain+and+range+errors+in+math+functions
>  For example, the following code ensures that
>  .BR log (3)'s
>  argument is not a NaN and is not zero (a pole error) or
>  less than zero (a domain error):
>  .in +4n
>  .nf
>
>  double x, r;
>
>  if (isnan(x) || islessequal(x, 0)) {
>     /* Deal with NaN / pole error / domain error */
>  }
>
>  r = log(x);
>
>  .fi
>  .in
>  The discussion on this page does not apply to the complex
>  mathematical functions (i.e., those declared by
>  .IR <complex.h> ),
>  which in general are not required to return errors by C99
>  and POSIX.1-2001.
>
>  The
>  .BR gcc (1)
>  .I "-fno-math-errno"
>  option causes the executable to employ implementations of some
>  mathematical functions that are faster than the standard
>  implementations, but do not set
>  .I errno
>  on error.
>  (The
>  .BR gcc (1)
>  .I "-ffast-math"
>  option also enables
>  .IR "-fno-math-errno" .)
>  An error can still be tested for using
>  .BR fetestexcept (3).
>  .fi
>  .in
>  .SH SEE ALSO
>  .BR gcc (1),
>  .BR errno (3),
>  .BR fenv (3),
>  .BR fpclassify (3),
>  .BR INFINITY (3),
>  .BR isgreater (3),
>  .BR matherr (3),
>  .BR nan (3)
>
> --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
