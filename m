Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbXCZP3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbXCZP3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 11:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbXCZP3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 11:29:09 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1611 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbXCZP3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 11:29:08 -0400
Message-ID: <4607E6A8.3040308@shadowen.org>
Date: Mon, 26 Mar 2007 16:28:40 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Con Kolivas <kernel@kolivas.org>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, "Martin J. Bligh" <mbligh@mbligh.org>
Subject: Re: debug rsdl 0.33
References: <20070319205623.299d0378.akpm@linux-foundation.org> <64bb37e0703251128q3f9db894u24c4638dcf97224a@mail.gmail.com> <200703260849.07943.kernel@kolivas.org> <200703260859.27272.kernel@kolivas.org> <46077AEE.8060507@shadowen.org>
In-Reply-To: <46077AEE.8060507@shadowen.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> Con Kolivas wrote:
> 
>> This is about the only place I can see the run_list is looked at unlocked. Can
>> you see if this simple patch helps? The debug patch is unnecessary now.
> 
> Tests queued with this patch.  Will let you know.

That patch had no effect on the problem.

...

Since then we have performed some more debugging on the issue and it
appears that the first stanza in next_dynamic_task is tripping,
triggering a "major_priority_rotation" and the resulting runq bitmap
indicating there is nothing to run.  Discussions with Con seem to
indicate that this is not possible :/.

Subsequent to that Con suggested testing a refactored RSDL patch.  That
patch seemed to work on the machine at hand, so tests have been
submitted for all the affected machines.

http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc4-mm1-rsdl-0.34-test.patch

...

Ok, the preliminary results are in and we seem to have good boots in the
three machines I was hitting early boot oops.  So I think we can say
that the new stack is a lot better than the old.

Con, have a Tested-by:

:/

-apw
