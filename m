Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbYIUWJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbYIUWJf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 18:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYIUWJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 18:09:28 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:51162 "HELO
	shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752482AbYIUWJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 18:09:27 -0400
Date: Sun, 21 Sep 2008 17:09:26 -0500
From: lkml@pengaru.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Honoring SO_RCVLOWAT in proto_ops.poll methods
Message-ID: <20080921220926.GA18569@fc6222126.aspadmin.net>
References: <20080920214229.GP2761@fc6222126.aspadmin.net> <20080920.152140.193698477.davem@davemloft.net> <20080920230046.GQ2761@fc6222126.aspadmin.net> <20080921092442.GS2761@fc6222126.aspadmin.net> <20080921151811.46328133@lxorguk.ukuu.org.uk> <20080921145134.GT2761@fc6222126.aspadmin.net> <20080921211337.74e8f1f1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080921211337.74e8f1f1@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 09:13:37PM +0100, Alan Cox wrote:
> Thats a gloriously insane way of trying to do HTTP/1.1, and one I'm not
> sure is actually viable in the real world because the TCP window may be
> smaller than the number of bytes required to find a Host: header - so you
> may simply not be able to receive it via MSG_PEEK. In particular mobile
> phone gateways have a nasty habit of using very small windows.
> 
> > I just don't see a good solution for what I'm doing other than MSG_PEEK
> > and SO_RCVLOWAT, any ideas?
> 
> I don't either, and while I don't agree that what you are doing for
> HTTP/1.1 is remotely sane there are probably other cases this would be
> both sane and useful which does suggest fixing it would be beneficial

I somewhat agree that it's insane, but it should be possible and what I've
done already works most of the time.  With some additional special handling
of the missing Host: case what I have might be a viable general case
solution.

For now httpx just drops the connection when Host: isn't found as it's a
work in progress.  I wanted to get this out there largely for you guys to
see "Hey maybe there's a practical need for MSG_PEEK & SO_RCVLOWAT behaving
differently than it does".  It seems to have been effective in this
respect and I am hugely appreciative of your attention, time, and input.
 
As a proof of concept httpx already has some people scratching their heads
because name-based vhosting can be a nightmare with the venerable Apache.  A
solution like mine could alleviate alot of that.  With some work and a way
to sleep on peek with a rcvbuf < rcvlowat there might be something quite
interesting for the web hosting world.

Cheers,
Vito Caputo


--------------------------------------------------------------------------------
For those of you on the list:  I had replied to Alan directly but since
Alan CC'd the list in his response I've continued with that format.  For
those of you in the dark, httpx is my insane app using the MSG_PEEK and
SO_RCVLOWAT being referred to above, you can find it here:
http://serverkit.org/modules/httpx/
