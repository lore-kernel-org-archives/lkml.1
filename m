Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbZCFLRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbZCFLRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 06:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZCFLR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 06:17:27 -0500
Received: from stinky.trash.net ([213.144.137.162]:59818 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbZCFLR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 06:17:26 -0500
Message-ID: <49B10641.9070908@trash.net>
Date: Fri, 06 Mar 2009 12:17:21 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: lguest: unhandled trap 13 in current -rc
References: <4993CCCE.6040403@trash.net> <49AE8C57.4080502@trash.net> <200903061726.04101.rusty@rustcorp.com.au>
In-Reply-To: <200903061726.04101.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thursday 05 March 2009 00:42:39 Patrick McHardy wrote:
>> Patrick McHardy wrote:
>>> When trying to run lguest in the current -rc, I get an "unhandled
>>> trap 13" and it stops. The address resolves to the rdmsr intruction
>>> in native_read_msr_safe(). -rc2 works fine, but I couldn't find
>>> any changes that looks related.
>>>
>>> .config is attached, more information available on request.
>> For the record, this is still broken in -rc7.
> 
> (Sorry, I missed the first mail to lkml).
> 
> Reproduced on one of my test machines (kvm doesn't show the problem here).
> 
> Subject: lguest: fix crash 'unhandled trap 13 at <native_read_msr_safe>'


Thanks Rusty, this fixed the problem for me.

There's a second problem, outgoing network performance using a routed
tap-interface is in the area of 20-30 kbit/second. I noticed this
previously (which is why I wanted to test the latest version), in
-rc2 what still worked was turning TSO/GSO etc. off, this seems to
be without effect in -rc7. I'll have a look at this myself tommorrow
unless someone beats me to it :)
