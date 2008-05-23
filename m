Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbYEWTmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbYEWTmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYEWTmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:42:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:57977 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbYEWTmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kmZX7Zv+RE6LEVP2fB0LGnxwDFvHTZTrtzPr7wHHSLH6NvnwvIhvOMwnjFdxeRcSQwH1Lre4skZZUrSGZAEu0eGEiHhVzirT89AooETWJk/muk5WI0eauTHYHQmQhCB+cFHRVPL5vsRywIt/Jsox4zqTgPl8jwIDNolFy5v+56I=
Message-ID: <19f34abd0805231242r32892322n6c0a25e06d93ff96@mail.gmail.com>
Date: Fri, 23 May 2008 21:42:14 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH 6/7] kbuild: make source and include paths absolute
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>, peter.oberparleiter@de.ibm.com,
       linux-kernel@vger.kernel.org, ltp-coverage@lists.sourceforge.net,
       oberparleiter@googlemail.com
In-Reply-To: <20080523190950.GA32541@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48313E08.8070904@de.ibm.com>
	 <20080522201724.cf4bd471.akpm@linux-foundation.org>
	 <20080523171840.GD28257@cs181133002.pp.htv.fi>
	 <20080523111707.89df9f67.akpm@linux-foundation.org>
	 <20080523190950.GA32541@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 9:09 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Fri, May 23, 2008 at 11:17:07AM -0700, Andrew Morton wrote:
>> On Fri, 23 May 2008 20:18:40 +0300
>> Adrian Bunk <bunk@kernel.org> wrote:
>>
>> > On Thu, May 22, 2008 at 08:17:24PM -0700, Andrew Morton wrote:
>> > > On Mon, 19 May 2008 10:44:56 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
>> > >
>> > > > From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
>> > > >
>> > > > Change all source and include paths to absolute form when
>> > > > CONFIG_GCOV_PROFILE is enabled.
>> > > >
>> > > > Example:
>> > > >
>> > > >   gcc -Idir1 -c a.c -o a.o
>> > > >
>> > > > will become
>> > > >
>> > > >   gcc -I/path/to/dir1 -c /path/to/a.c -o a.o
>> > > >
>> > > > Required by the gcov profiling infrastructure: when compiling with
>> > > > option -fprofile-arcs, gcc stores file names inside object files.
>> > > > Relative paths prevent the gcov tool from finding corresponding source
>> > > > files.
>> > >
>> > > I don't like this.  It converts the compiler error messages from
>> > > relative paths to absolute paths which is rather obnoxious when
>> > > all kernel developent is (or should be) base-directory-agnostic.
>> >
>> > The compiler error messages are already absolute paths when using O=
>> > (see e.g. all error messages sent by me in recent years).
>> >
>>
>> Well I guess that's understandable with O=.
>>
>> But I find it rather nasty.  (I guess it'd be less nasty if I were to
>> get off my butt and work out how to teach rxvt that "/" is a word
>> separator).
>>
>> What do others think?
>
> That the gcov tool has a bug if it insist on using absolute paths.
> And thus we should fix gcov and not workaround it in the kernel.

IIRC, there was also the slight problem that all uses of __FILE__
(there are quite a few in the kernel) will also now be absolute and
increase the size of the vmlinux image by quite a bit.

Yeah... http://lkml.org/lkml/2006/4/25/40


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
