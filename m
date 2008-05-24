Return-Path: <linux-kernel-owner+w=401wt.eu-S1760337AbYEXGZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760337AbYEXGZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 02:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbYEXGZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 02:25:49 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:30392 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbYEXGZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 02:25:49 -0400
Message-ID: <fa686aa40805232325w65d4f706i50798121a8cce263@mail.gmail.com>
Date: Sat, 24 May 2008 00:25:47 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [spi-devel-general] [PATCH 3/4] spi: Add OF binding support for SPI busses
Cc: spi-devel-general@lists.sourceforge.net,
       "Segher Boessenkool" <segher@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       fabrizio.garetto@gmail.com,
       "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <200805221926.24112.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
	 <716a0f1b6c9a544b480c06a329072483@kernel.crashing.org>
	 <fa686aa40805211233h72a258bpf8c945b9f662d6ee@mail.gmail.com>
	 <200805221926.24112.david-b@pacbell.net>
X-Google-Sender-Auth: 2a688715e228fa0a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 8:26 PM, David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 21 May 2008, Grant Likely wrote:
>> > spi-controller {
>> >        #address-cells = 2;
>> >        #size-cells = 0;
>> >        some-device@0,f000 { reg = < 0 f000 >; } // CS 0, SPI address f000
>> >        some-device@1,f000 { reg = < 1 f000 >; } // CS 1, SPI address f000
>> >        some-device@1,ff00 { reg = < 1 ff00 >; } // CS 1, SPI address ff00
>> > }
>>
>> For SPI the CS # *is* the address.  :-)
>>
>> Unlike I2C, SPI doesn't impose any protocol on the data.  It is all
>> anonymous data out, anonymous data in, a clock and a chip select.
>
> Very true ... but then there are SPI chips which embed addressing.
>
> I have in mind the mcp23s08 (and mcp23s17) GPIO expanders, which
> support up to four chips wired in parallel on a given chipselect.
> The devices are distinguished by how two address pins are wired;
> and two bits in the command byte must match them.  (I think they
> just recycled an I2C design into the SPI world.)

Very good point.  Okay, so we cannot assume any correlation between
the number of CS lines and the number of child nodes to the SPI bus.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
