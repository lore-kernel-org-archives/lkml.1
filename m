Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbXD1DgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbXD1DgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 23:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932526AbXD1DgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 23:36:23 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:14681 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458AbXD1DgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 23:36:22 -0400
X-IronPort-AV: i="4.14,463,1170662400"; 
   d="scan'208"; a="56868757:sNHT51951357"
To: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
X-Message-Flag: Warning: May contain useful information
References: <20070423141123.GA21174@skybase>
	<20070423104534.51bac974.akpm@linux-foundation.org>
	<20070425112133.4ae86399.randy.dunlap@oracle.com>
	<20070425143011.57247c1d.akpm@linux-foundation.org>
	<20070425172447.1576c399.akpm@linux-foundation.org>
	<20070426003911.GA19383@redhat.com> <4630109F.6090002@oracle.com>
	<20070425200207.77a2721a.akpm@linux-foundation.org>
	<20070428030805.GA13331@redhat.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 27 Apr 2007 20:36:17 -0700
In-Reply-To: <20070428030805.GA13331@redhat.com> (Dave Jones's message of "Fri, 27 Apr 2007 23:08:05 -0400")
Message-ID: <ada1wi5npam.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Apr 2007 03:36:17.0399 (UTC) FILETIME=[6126B070:01C78946]
Authentication-Results: sj-dkim-6; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim6002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > http://www.codemonkey.org.uk/projects/checkpatch/example.log shows
 > what fell out of running it on my mbox of lkml from the past month.
 > Some of them are kinda noisy, and perhaps should be moved under --pedantic
 > 
 > I'm all ears for additional regexps, bug reports or other suggestions.

Looks great... however I notice a few obvious false positives in the
example log:

 > Don't init statics to 0/NULL:
 > 94312:+static const struct in6_addr in6addr_v4mapped = { { { [10] = 0xff, [11] = 0xff } } };

ummm?

 > 137054:+static uint32_t drvr_ver  = 0x02200207;

that ain't zero...

 > 230079:+                path->static_rate = 0;

and that ain't a static variable.

I guess trying to parse C in a regexp is a little tricky.

Also, it would be nice to be able to do something like

    git diff v2.6.20..|perl ~/checkpatch.pl -

rather than having to create a temp file -- as it stands that command
produces

    unknown option: -
    usage: findbugs.pl [-options] file(s)
      -allsource : check entire source file, not just '+' patch lines
      -pedantic : TBD
      -style : TBD
      -v, --verbose : verbose
      -h, --help : this help text
    Version: 002

And even worse

    git diff v2.6.20..|perl ~/checkpatch.pl

just silently does nothing (maybe a "no input files" warning would be
a good clue for people).

 - R.
