Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbYJGRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbYJGRTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYJGRTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 13:19:12 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:33333 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753040AbYJGRTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 13:19:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xZfQFUoCW+PVtAi24Iv25PSq/z2bJQGaf+2Zv8BHDd/VDAznE7eRgrZEOALsKAIK5X1RTHkBO4XBFD97rXGIn5WN8CMOAKqVWi2SBoaNflHRvGVmmSoCJAkLlZdg+fQYesZJ/+t1rMyVQ+EdgdQpuDEB6geduY5LvBFn27kCKkI=  ;
X-YMail-OSG: fcOAj0sVM1mTmNlrgW5Fcu0bCjHBlLqtTvPbq5SM4YieKiossur7m5826b1M6k56w6fouKd_bcOzKLWnncSa_xm099TtBPLdo_J3NzjnUYxNtU6wb8N_OImOauCW3PJIGUo-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH/RFC] hardware irq debouncing support
Date: Tue, 7 Oct 2008 10:19:08 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Tony Lindgren <tony@atomide.com>
References: <200809241251.32606.david-b@pacbell.net> <20081006151003.GB1380@ucw.cz>
In-Reply-To: <20081006151003.GB1380@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810071019.08647.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 October 2008, Pavel Machek wrote:
> How is this going to work with shared interrupt lines? If one handler
> wants debouncing and second handler does not, you'll loose interrupts
> for second handler?

That'd be as hardware dependent as the bad decision to mix such
signals on one line in the first place!  As a rule, nothing gets
lost -- systems care about such events stable at the millisecond
granuarity, not nanosecond -- but I can't speak for all possible
bad hardware designs.

Recall that the systems with this support generally have no
shortage of interrupt lines, and thus no reason to share them.
The boards I'm working with right now have over two hundred
GPIOs, and all but a handful of them (if you exaggerate "two"
to be a "handful"!) can be configured as interrupt inputs.

And there's strong incentive NOT to share them ... if a signal
is dedicated to e.g. MMC1 card detect, it can gate the regulator
dedicated to that slot; but not if that signal is shared with
some other status.  If two simple buttons both trigger the same
interrupt, you can't tell them apart.  And so on.

- Dave
