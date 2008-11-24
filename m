Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYKXSJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYKXSJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbYKXSIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:08:50 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:8613 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbYKXSIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:08:49 -0500
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Nov 2008 13:08:48 EST
Message-ID: <492AE9CB.4020302@caviumnetworks.com>
Date: Mon, 24 Nov 2008 09:52:11 -0800
From: Chad Reese <kreese@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.0.14eol) Gecko/20070505 Iceape/1.0.9 (Debian-1.0.13~pre080323b-0etch3)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: "Kevin D. Kissell" <kevink@paralogos.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: Is there no way to shared code with Linux and other OSes?
References: <4927C34F.4000201@caviumnetworks.com> <4927D6E0.4020009@paralogos.com> <Pine.LNX.4.64.0811221109330.29539@anakin> <4927E2A4.5000702@paralogos.com> <20081122153542.GB31703@linux-mips.org> <49285895.6020303@caviumnetworks.com> <20081124131415.GA21403@linux-mips.org>
In-Reply-To: <20081124131415.GA21403@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Nov 2008 17:52:12.0838 (UTC) FILETIME=[6150CC60:01C94E5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle wrote:
> I'll start off my answer with a bit of history.  A few years ago the Linux
> codebase was growing at exponentional speed not last from contributions
> from other projects and there were few standards in the Linux world.  As
> the result the code base was highly inconsistent in many aspects,
> including coding style and typedefs.  It made maintenance and even just
> understanding the code base painful.  Then on a few occasions Linus
> decreed certain standards such as code to be formatted to fit into 80
> colums.  Other standards arose from a common understanding.

I appreciate the history and agree that coding standards are a necessary
thing. To be clear, I'm not looking for some one to say "ok, you can put
your stuff in". I'm more looking for other people that have already had
this problem and may have come up with a better solution. Even something
a simple as a smarter indent program might be a good idea. I've always
felt that an automated formatter normally causes more harm than good,
but sometimes they are a necessary evil.

> Re divergent code base - I see your issue but the problem is both ways.
> Historic example is Broadcom which contributed the headers for the Sibyte
> SOC family.  The headers are generated using inhouse tools just as yours
> and we'd like to change them - but all those changes conflict with
> Broadcom's bi-annual contribution which are bascially are versions
> re-generated with their latest tools and from their latest RTL.

In principle I agree, but in the specifics for the Octeon code I have
trouble with this. Currently we put all hardware register definitions in
two files, one for bit typedefs and one for the corresponding physical
address. These two files contain nothing other than raw register
definitions and are generated from RTL. Lots of the feedback we've
gotten from the community want this broken up such that registers are
defined in smaller groups where they are used. This makes sense if
you're talking about stuff that is hand maintained. Across the various
Octeon chip there are something around 1500 hardware specific registers.
Nobody is going to maintain something like that by hand. I'm sure years
from now when someone is trying to figure out how to program some Octeon
feature having the register definitions already in the kernel will help
tremendously.

> OS compatibility layers are another subject.  They simplify maintenance
> for the one and make it harder for the other.  In general in the Linux
> world we've made not so positive experience with such glue code layers,
> so we tend to limit if not avoid their use.
> 
> Another factor is that usually long after the contributing company has
> already forgotten about their code I'm the guy who still is stuck with it.
> For many more years ...

The unfortunate facts of life is that this will likely happen again.
Luckily Linux is currently requested by our customers heavily, so it
will be supported better than other open source OSes. I'm just worried
that code fixes will not propagate to other OSes simply because it isn't
possible to share code. The Octeon FreeBSD port currently shares quite a
bit of low level Octeon code with Linux. If the current Octeon Linux
submit process continues, this will not be possible.

After spending quite a bit of time making sure the Octeon "hal" code
compiles and works cleanly under the four different mips abis, with
either a cavium compiler or a standard one for multiple OSes, I hate to
see that work be for nothing.

Ok, I'll stop whining now...

Chad
