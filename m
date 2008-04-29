Return-Path: <linux-kernel-owner+w=401wt.eu-S1760903AbYD2WLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903AbYD2WLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758930AbYD2WKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:10:21 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:38843 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755505AbYD2WKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:10:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LfO+6tXNGUA4q1JgJJJ1vcItVhtUp33RPet3U4kJiE7b8nJatvwGWoDJ/rwa77DKj/rPHYBqEONQLoryQT59APbqMyiP6cl8BM7swbv3eWire3XKIbR5SNakTNyhWhBsJ7YUFuGIQOSNRHhfaeFu8WiAQ28xSU4xYV1IuDU97mo=  ;
X-YMail-OSG: m6O8QiEVM1nKCf2MaA33A5Oox1Vo76uM1F3o1qqU0rI445Ul3l_WKkRiY2OuShpk2Yxv10vzKPOee61cZHczDAmKeqxgmBw1RvbCs9ObE1UXOFZC2dwgYkTHZmVjKIOfha4-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Trent Piepho <tpiepho@freescale.com>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Date: Tue, 29 Apr 2008 14:56:52 -0700
User-Agent: KMail/1.9.6
Cc: Ben Nizette <bn@niasdigital.com>, lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
References: <200804281239.51729.david-b@pacbell.net> <1209472526.311.50.camel@moss.renham> <Pine.LNX.4.64.0804291022190.15041@t2.domain.actdsltmp>
In-Reply-To: <Pine.LNX.4.64.0804291022190.15041@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804291456.52889.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2008, Trent Piepho wrote:
> > Sorry if I'm being dense; how do you want this bit to work?  As I see
> > it, there are a few options:
> >
> > 1) Have the files named as you suggest and all of them always present,
> > albeit read-only until export.  Very easy to use, easy to discover which
> > file is which, a decent bit of memory usage having them all listed.
> 
> Well, is it really that much?  There are 579 files under /sys/class/tty.  But
> suppose it is too much (why isn't tty too much then?), then we can do 3.

I just ssh'd into three embedded boards I have handy, and they have
respectively four, four, and seven entries there.  That "seven"
case is actually incorrect ... the other three serial ports aren't
connected to anything.

So:  yes, adding a few hundred useless sysfs nodes *IS* a problem
in the target environment of embedded boards.

Note that "read-only until export" is far from straightforward
to achieve.


> > 3) Have the files named as you suggest, explicit export/request but
> > better parsing behind the control file so something like
> > echo "export pca9557-0:5" > control
> > works.  Very very nice for the user, big heavy back end.
> 
> The back end doesn't seem that big to me.  Here's code for it.

Which fails in a common case:  chip labels are not unique.


> If anything, 
> the parsing code is simpler than what David has.

Apples vs oranges.  Use the same command syntax if you're going
to make comparisons; I can save even more with "+export/-unexport"
syntax.  For comparable syntax, your stuff *IS* bigger.


> David's code for parsing the control file plus code for generating a mapping
> range file would certainly be larger.

The #3 option presumes some file listing chips and ranges too,
since GPIOs are exported only on demand.  Ditto #2 and #4...

- Dave

