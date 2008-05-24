Return-Path: <linux-kernel-owner+w=401wt.eu-S1759748AbYEXGYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759748AbYEXGYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 02:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755380AbYEXGYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 02:24:34 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:29163 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbYEXGYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 02:24:33 -0400
Message-ID: <fa686aa40805232324k1505d02aj6790d0217482c732@mail.gmail.com>
Date: Sat, 24 May 2008 00:24:32 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
Cc: cbouatmailru@gmail.com, linuxppc-dev@ozlabs.org,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       fabrizio.garetto@gmail.com
In-Reply-To: <200805211816.10753.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
	 <20080516224916.GA16702@zarina>
	 <fa686aa40805162202m336aade4qd6cfa5b17d6f3892@mail.gmail.com>
	 <200805211816.10753.david-b@pacbell.net>
X-Google-Sender-Auth: 046f1391e11f6152
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 7:16 PM, David Brownell <david-b@pacbell.net> wrote:
> On Friday 16 May 2008, Grant Likely wrote:
>> In my mind; platform_data and the device tree are all about the same
>> thing: representation.  In other words, how to describe the
>> configuration of the hardware independent of the driver itself.
>
> Platform_data isn't what I'd call independent of drivers.
>
> The reason the data is there in the first place is that
> the driver needs it ... and chose not to hard-wire it.

Oh, of course the driver needs it!  I'm not claiming otherwise.  More
what I mean is that the driver doesn't need to be loaded or even
configured in for the platform code to make use of pdata.

>> One of the things I find rather interesting is just how frequently
>> drivers using platform data structures have a big block of code which
>> simply copy pdata fields into identically named fields in the device
>> private data...
>
> ... because platform data was designed as a partial template
> for that driver, letting it do that.  (Sometimes without even
> doing scale conversions.)  As drivers grow functionally, they
> sometimes end up needing more platform data fields, to expose
> data that previously didn't matter.
>
> Whether that data can usefully be stored in flash (or ROM)
> and handed out through the bootloader is something of a
> manufacturing issue.

I do not dispute any of that.  My point, however, is that pdata is
typically used simply as a representation that is convenient for
platform code to pass that data into the driver and that often drivers
don't use that representation directly.  Instead, the data is
explicitly copied explicitly field by field into the driver at probe
time and is not touched again.  That says to me that driver developers
view pdata as somewhat decoupled from the internal workings of the
driver and in the case of many powerpc devices a different
representation is more convenient; namely a device tree node.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
