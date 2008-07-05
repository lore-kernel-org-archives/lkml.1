Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYGEEgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYGEEgX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 00:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbYGEEgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 00:36:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51614 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbYGEEgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 00:36:13 -0400
Message-ID: <486EFA28.9040105@garzik.org>
Date: Sat, 05 Jul 2008 00:35:52 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, David Woodhouse <dwmw2@infradead.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       hugh@veritas.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
References: <1215093175.10393.567.camel@pmac.infradead.org> <20080703173040.GB30506@mit.edu> <1215111362.10393.651.camel@pmac.infradead.org> <20080703.162120.206258339.davem@davemloft.net> <486D6DDB.4010205@infradead.org> <87ej6armez.fsf@basil.nowhere.org> <1215177044.10393.743.camel@pmac.infradead.org> <486E2260.5050503@garzik.org> <1215178035.10393.763.camel@pmac.infradead.org> <486E2818.1060003@garzik.org> <20080704143058.GB23215@mit.edu>
In-Reply-To: <20080704143058.GB23215@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Fri, Jul 04, 2008 at 09:39:36AM -0400, Jeff Garzik wrote:
>> You have been told repeatedly that cp(1) and scp(1) are commonly used to  
>> transport the module David and I care about -- tg3.  It's been a single  
>> file module since birth, and people take advantage of that fact.
> 
> Here, I think I'll have to respectly disagree with you and say that
> you are taking things too far.  I don't think scp'ing individual
> modules around counts as an "exported user interface" the same way,
> say "make install; make modules_install" is a commonly understand and
> used interface by users and scripts (i.e., such as Debian's make-kpkg,
> which does NOT know about "make firmware_install", BTW).

It's not just netdev developers that use that method, root (notably 
router) image and driver disk build scripts use it too.  They've been 
able to skate around module dependencies because network drivers rarely 
have module dependencies or require big multi-module systems.

Example -- the driver disk kit that RH informally gave out, which was 
widely used, but does not use normal kernel build processes:

	http://people.redhat.com/dledford/mod_devel_kit.tgz

Even if one modifies 'make modules_install' as discussed[1], kits like 
these will report "100% success! driver disk created", yet ship a dead 
driver disk.

That is why putting the firmware in the kernel image, as dwmw2 has done, 
does not fix regressions here:  driver disk authors do not necessarily 
have the luxury of updating the kernel.

Conclusion - we should not build a system today that /excludes/ the 
possibility of building drivers as they are built today -- with the 
firmware inside the module [if CONFIG_FOO=m] or kernel image [if 
CONFIG_FOO=y].

That is the only path that gives everyone a chance to deal with this 
transition.

	Jeff





[1] a laudable and useful thing to do, and it sounds like it is being 
accomplished.  great!

