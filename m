Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbXHBWP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbXHBWP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbXHBWPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:15:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47325 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbXHBWPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:15:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46B2578A.805@s5r6.in-berlin.de>
Date: Fri, 03 Aug 2007 00:15:38 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange> <p73vebxmysb.fsf@bingen.suse.de> <Pine.LNX.4.60.0708022231160.6774@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0708022231160.6774@poirot.grange>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> On Thu, 2 Aug 2007, Andi Kleen wrote:
>> 6.7.8.14 of C99:
>> ``
>> An array of character type may be initialized by a character string literal, optionally
>> enclosed in braces. Successive characters of the character string literal (including the
>> terminating null character if there is room or if the array is of unknown size) initialize the
>> elements of the array.
>> ''
>>
>> Note the "if there is room".
>>
>> I believe the rationale is that it still allows to conveniently initialize 
>> non zero terminated strings.
> 
> Right, I accept that it will compile, but I don't understand why "01234" 
> produces a warning and "0123" doesn't? Don't think C99 says anything about 

How should gcc know whether you actually wanted that char foo[len] to
contain a \0 as last element?

Given the respective command line switches, gcc does warn in some cases
where it is guesswork whether what you typed is what you intended.  For
example

	if (i = j())

is reason for gcc to warn even if that might exactly be what you wanted.
However this construct can easily be annotated as

	if ((i = j()))

to show to gcc and to carbon-based bipedals that you indeed wanted this.

Now there is no nice way to make an annotation that says "look, I'm
going to initialize an array of char with a string literal now, and the
resulting array will contain a non-zero member as last element, and I
mean it".  And since there is no such annotation possible, gcc does not
warn and demand that you annotate the perfectly valid and 100%
spec-compliant construct char a[4] = "1234";.
-- 
Stefan Richter
-=====-=-=== =--- ---==
http://arcgraph.de/sr/
