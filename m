Return-Path: <linux-kernel-owner+w=401wt.eu-S1422654AbXD3Aki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422654AbXD3Aki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 20:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422642AbXD3Aki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 20:40:38 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:44523 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422654AbXD3AkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 20:40:11 -0400
Date: Sun, 29 Apr 2007 17:43:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-Id: <20070429174319.222cfac5.randy.dunlap@oracle.com>
In-Reply-To: <ada1wi5npam.fsf@cisco.com>
References: <20070423141123.GA21174@skybase>
	<20070423104534.51bac974.akpm@linux-foundation.org>
	<20070425112133.4ae86399.randy.dunlap@oracle.com>
	<20070425143011.57247c1d.akpm@linux-foundation.org>
	<20070425172447.1576c399.akpm@linux-foundation.org>
	<20070426003911.GA19383@redhat.com>
	<4630109F.6090002@oracle.com>
	<20070425200207.77a2721a.akpm@linux-foundation.org>
	<20070428030805.GA13331@redhat.com>
	<ada1wi5npam.fsf@cisco.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 20:36:17 -0700 Roland Dreier wrote:

>  > http://www.codemonkey.org.uk/projects/checkpatch/example.log shows
>  > what fell out of running it on my mbox of lkml from the past month.
>  > Some of them are kinda noisy, and perhaps should be moved under --pedantic
>  > 
>  > I'm all ears for additional regexps, bug reports or other suggestions.
> 
> Looks great... however I notice a few obvious false positives in the
> example log:
> 
>  > Don't init statics to 0/NULL:
>  > 94312:+static const struct in6_addr in6addr_v4mapped = { { { [10] = 0xff, [11] = 0xff } } };
> 
> ummm?

fixed

>  > 137054:+static uint32_t drvr_ver  = 0x02200207;
> 
> that ain't zero...

not?  fixed.

>  > 230079:+                path->static_rate = 0;
> 
> and that ain't a static variable.

ack, fixed.

> I guess trying to parse C in a regexp is a little tricky.
> 
> Also, it would be nice to be able to do something like
> 
>     git diff v2.6.20..|perl ~/checkpatch.pl -

I'll check into how to treat "-" as STDIN.

> rather than having to create a temp file -- as it stands that command
> produces
> 
>     unknown option: -
>     usage: findbugs.pl [-options] file(s)
>       -allsource : check entire source file, not just '+' patch lines
>       -pedantic : TBD
>       -style : TBD
>       -v, --verbose : verbose
>       -h, --help : this help text
>     Version: 002
> 
> And even worse
> 
>     git diff v2.6.20..|perl ~/checkpatch.pl
> 
> just silently does nothing (maybe a "no input files" warning would be
> a good clue for people).

or print usage info?


Thanks.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
