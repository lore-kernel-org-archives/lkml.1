Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbXK0ET0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbXK0ET0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 23:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbXK0ETT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 23:19:19 -0500
Received: from qmta07.westchester.pa.mail.comcast.net ([76.96.62.64]:46203
	"EHLO QMTA07.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755204AbXK0ETT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 23:19:19 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Nov 2007 23:19:18 EST
X-Authority-Analysis: v=1.0 c=1 a=PGn15t7drhMA:10 a=GG0w21oKAAAA:8 a=pQs5aej7AAAA:8 a=Cl1uwOHQh07nyNwJ_2kA:9 a=RF9A9rAkMEI3anD7jCLicO-t0KkA:4 a=c5zHXd76wwQA:10
Message-ID: <474B9944.5050804@comcast.net>
Date: Mon, 26 Nov 2007 23:12:52 -0500
From: John Richard Moser <nigelenki@comcast.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       travis@sgi.com, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 08/45] cpu alloc: x86 support
References: <20071120011132.143632442@sgi.com> <200711200416.32954.ak@suse.de> <Pine.LNX.4.64.0711191945260.21813@schroedinger.engr.sgi.com> <200711201301.25373.ak@suse.de>
In-Reply-To: <200711201301.25373.ak@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Andi Kleen wrote:
> On Tuesday 20 November 2007 04:50, Christoph Lameter wrote:
>> On Tue, 20 Nov 2007, Andi Kleen wrote:

> You could in theory move the modules, but then you would need to implement
> a full PIC dynamic linker for them  first and also increase runtime overhead
> for them because they would need to use a GOT/PLT.

On x86-64?  The GOT/PLT should stay in cache due to temporal locality. 
The x86-64 instruction set itself handles GOT-relative addressing rather 
well; what's a 1% loss on x86 is like 0.01% on x86-64, so I'm thinking 
100 times better?

I think I got this by `-fpic -pie` compiling nbyte benchmark versus 
fixed position, each with and without on 32-bit (which made about a 1% 
difference) and on 64-bit (which made a 0.01% difference).  It was a 
long time ago.

Still, yeah I know.  Complexity.

(You have the ability to textrel these things too, and just rewrite 
non-PIC, depending on how you feel about that)
-- 
Bring back the Firefox plushy!
http://digg.com/linux_unix/Is_the_Firefox_plush_gone_for_good
https://bugzilla.mozilla.org/show_bug.cgi?id=322367
