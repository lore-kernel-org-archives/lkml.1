Return-Path: <linux-kernel-owner+w=401wt.eu-S932242AbZKBSnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbZKBSnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932171AbZKBSnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:43:13 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:36288 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107AbZKBSnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:43:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=slMwjpFwtUwLhYqetqO3I8a9AypS8Mp6IQQgHyOL7fn/l/dj9c1fttX8I2pD8cKVau
         e+SoJ13le9wWK59ZgtvJSeJYoi8R3bxPJ1mgeHdWACgQlz/npMy4Vt8WdMB5AXNm8T+Q
         /AWzovdS9/a8+O10R0kF6B17cncNPm5PThElA=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2009-10-28
Date: Mon, 2 Nov 2009 19:43:10 +0100
User-Agent: KMail/1.9.10
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Luis Correia <luis.f.correia@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1256886023.3555.5.camel@johannes.local> <efe7343f0911020932l21a570c8u9478568329d38e2c@mail.gmail.com> <4AEF1894.2010809@xenotime.net>
In-Reply-To: <4AEF1894.2010809@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911021943.12069.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well and then another rt2x00 developer discovered this nice little
fight about rt2x00 on the mailinglists...

First for the record, because at the start people where talking about the
maintainership of rt2x00, one thing needs to be straight:

As mentioned in the MAINTAINERS file, the rt2x00 project is listed as maintainer
for the rt2x00 drivers. The rt2x00 drivers include _all_ drivers in the
drivers/net/wireless/rt2x00 folder.

At this time I am hold the position within the rt2x00 team which is making the
decisions about the rt2x00 code and design.
I am also the one that is (N)Acks the patches from others when they are send
to the rt2x00-users or linux-wireless mailinglist.

As for my behavior in discussions:

I am doing my best to listen to all complains regarding the rt2x00 code and design and
improve it if the complainer has a valid point. However, obviously I can disagree with
the complainer and in that case I will explain to that person _why_ I disagree. It is up
to the complainer to convince me that he is right, agree with my response, or whine.

Now as for more specific responses:

On Thursday 29 October 2009, Bartlomiej Zolnierkiewicz wrote:
> rt2800 drivers have their maintainers and I would like to know what they
> are doing besides complaining about users and staging tree..

Working for Avanade, Zarafa and as freelancer for Linux Magazine.
But I guess you mean rt2x00 specific work?
Well that list consists of:
 - Listening to people complain
 - Responding to those people, because otherwise they complain that they are being ignored.
 - Following bug reports, and request testing or additional information if required
 - Bugfixing
 - Reviewing patches from contributors
 - Applying patches from contributors
 - Discussing improvements over patches from contributors

Well nothing of this list should be new to you, but apparently you needed some confirmation.

On Thursday 29 October 2009, Johannes Berg wrote:
> On Thu, 2009-10-29 at 07:20 -0700, David Miller wrote:
> 
> > In case you're concerned, I actually agree with John and others
> > on this issue, and disagree with your position.
> 
> In this particular case, I think it makes more sense to duplicate the
> code _especially_ because it's not working yet. That frees people
> hacking on it of having to worry about breaking other devices.

Thank you Johannes, that is exactly what I was trying to tell Bartlomiej
in the previous discussion.

On Wednesday 28 October 2009, Bartlomiej Zolnierkiewicz wrote:
> I find it rather disappointing that all my review comments regarding
> rt2800pci support were just completely ignored and then the initial
> patch was merged just as it was..

Your code review comments were commented upon with my reasons
why this code duplication exists. I even admitted that when the time is
ready I will remove the code duplication.

On Thursday 29 October 2009, Bartlomiej Zolnierkiewicz wrote:
> Quite the contrary, I'm pretty confident that addressing my review concerns
> would result in better RT28x00 / RT30x0 support in the very near future.

The review concerns regarding the duplicate code would only reduce the
amount of code. It would not magically fix bugs (at least the chance of that
would be quite small).

So far rt2800usb performs better then rt2800pci, and the difference gets
only bigger when I use the exact same register initialization from rt2800usb
in rt2800pci.

But Bartjmoiej knows that the register initialization can be exactly the same,
from his experience with the staging drivers.
So far hasn't been interested in sharing the knowledge in what must be
changed in rt2800pci/usb to make them both work with the same register
initialization.

On Monday 02 November 2009, Randy Dunlap wrote:
> Luis Correia wrote:
> > [huge snip]
> > I've searched on my GMail archives and the only patch Bart has
> > provided so far for the rt2x00 project is this:
> > 
> > [PATCH] MAINTAINERS: rt2x00 list is moderated
> > 
> > Which, while technically correct, adds nothing to the project.
> 
> whatever.  That patch still needs to be applied.

And I haven't seen anybody stating the opposite...

Ivo
