Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbXE3WMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbXE3WMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758375AbXE3WMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:12:01 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:35565 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758253AbXE3WL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:11:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Qbzlh3rEefN+2ySilXbJifkcz2WSUqVgM12CXi1XIcHV8nKqGuiEfz5WftbrcIwtCLed3XF8d2mU8/wsYNuy5UReIWEaqfy2uHRrctgC9aSPuB1w1twZCkeVeOqZnRJa5+JS1A6HpBQoJcGal0q/nHJoT6XUWEXUp/BtCvybC5Q=
Message-ID: <a781481a0705301511p69387b2ep754c8c754ba09f36@mail.gmail.com>
Date: Thu, 31 May 2007 03:41:57 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/3] hexdump: more output formatting
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, hugh@veritas.com
In-Reply-To: <465DF49B.7040100@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>
	 <20070524073131.GA17501@elte.hu>
	 <Pine.LNX.4.64.0705241418270.31613@schroedinger.engr.sgi.com>
	 <20070524142908.f39f42ea.akpm@linux-foundation.org>
	 <20070524145517.1f32cd94.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com>
	 <20070530143428.2f20446a.randy.dunlap@oracle.com>
	 <a781481a0705301456n246e7185ife2a144eae3179b3@mail.gmail.com>
	 <465DF49B.7040100@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Satyam Sharma wrote:
> > Hello Randy,
> >
> >> Add a prefix string parameter.  Callers are responsible for any
> >> string length/alignment that they want to see in the output.  I.e.,
> >> callers should pad strings to achieve alignment if they want that.
> >>
> >> Add rowsize parameter.  This is the number of raw data bytes
> >> to be printed per line.  Must be 16 or 32.
> >>
> >> Add a group_size parameter.  This allows callers to dump values
> >> as 1-byte, 2-byte, 4-byte, or 8-byte numbers.  Default is
> >> 1-byte numbers.  If the total length is not an even multiple
> >> of group_size, 1-byte numbers are printed.
> >
> > I wonder if (over-)engineering could hurt its adoption by more kernel
> > users. There aren't very many 8-argument monsters in the kernel,
> > and one would expect hexdump() to be easier on the fingers to
> > type? :-) Why not just continue with reasonable default/fixed rowsize
> > and groupsize values?
>
> Yes, one can try to satisfy the users/callers by adapting to their
> needs (wishes), which requires parameters or such; or one can have
> no callers and end up with (around 11 currently) different hex dump
> functions in the kernel source tree, but no users of lib/hexdump.c.

Yes, you're right, but I was just wondering whether any users really
cared enough about the rowsize and groupsize, also seeing that
accommodating these two args leads to a lot of increase in code.

> But it won't take much more "requirements" for me to drop the patch.

Please, don't drop this! I only complained because when global or
commonly-used functions have very long arglists, one tends to forget
which arg goes at which number, and it becomes necessary to write
the calls with having the prototype simultaneously open in another
terminal for reference! ...

> >> Add an "ascii" output parameter.  This causes ASCII data output
> >> following the hex data output.
> > [...]
> >> +       if (!ascii)
> >> +               goto nil;
> >> +
> >> +       if ((lx + 1) < linebuflen)
> >>                 linebuf[lx++] = ' ';
> >> -       }
> >> -       for (j = 0; (j < 16) && (j < len) && (lx + 2) < linebuflen; j++)
> >> +       for (j = 0; (j < rowsize) && (j < len) && (lx + 2) <
> >> linebuflen; j++)
> >>                 linebuf[lx++] = isprint(ptr[j]) ? ptr[j] : '.';
> >> +nil:
> >>         linebuf[lx++] = '\0';
> >
> > if (ascii) {
> > ...
> > }
> >
> > linebuf[lx++] = '\0';
> >
> > would help lose a goto and label.
>
> The label has another reference already, so it wouldn't be lost.

Oh yes, I'd missed that if (!len) goto nil; -- sorry for the noise.

Thanks,
Satyam
