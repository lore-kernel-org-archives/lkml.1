Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbZB1MwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbZB1MwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 07:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZB1MwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 07:52:06 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42438 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZB1MwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 07:52:05 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49A932D6.6070502@s5r6.in-berlin.de>
Date: Sat, 28 Feb 2009 13:49:26 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alex Buell <alex.buell@munted.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: Unused modules in 2.6.x
References: <20090225175249.30e47b85@lithium.local.net> <20090225192810.GA6150@kroah.com>
In-Reply-To: <20090225192810.GA6150@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Feb 25, 2009 at 05:52:49PM +0000, Alex Buell wrote:
>> Hi,
>>
>> Perhaps I missed something when the 2.6.x kernels got started a few
>> years back, but why is it not possible for unused modules to be
>> automatically unloaded anymore i.e with rmmod -a? I remember being able
>> to do that with the 2.2.x and 2.4.x series a long time ago.
> 
> Because if you do that, lots of modules that were being "used" by the
> system would get unloaded (usb host controllers, network drivers, etc.)
> 
> So it makes sense not to do that anymore.  See the linux-kernel archives
> about 6 years ago for details if you are curious about this historical
> issue (hint, it could burn you very badly even in 2.2 and 2.4...)

Alex,

the "use count" tracks how many sites in the kernel might be using
symbols in a module (call functions of a module etc.).  The "use count"
does *not* track anything higher-level than that, e.g. (as pointed out
by Lennart) "this module might soon come in handy to start accessing
some hardware" or (as pointed out by Michael) "this module provides
functionality for one of the links in a currently active IO path".

So, the meaning of Greg's "could burn you" in kernel 2.6 is basically:
Unloading of seemingly unused modules won't crash the kernel (occasional
driver bugs excepted) but it might switch off kernel functionality which
you still intended to use.

But why don't we count "this module provides functionality for one of
the links in a currently active IO path" too, generally?¹  Because for
the kernel, "user requests to unbind this driver from that device" is
merely yet another kind of a family of events like "user plugged out
that cable", "user ejected this card", "user sent a shutdown request to
that peer" etc.

------
¹)  Only in very simple cases is "is part of an IO path"
indistinguishable from "another kernel site uses symbols of this
module"; and there are very rare exceptional cases in which we do count
"is part of an IO path" explicitly for specific reasons.
-- 
Stefan Richter
-=====-==--= --=- ===--
http://arcgraph.de/sr/
