Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbYIWB7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbYIWB7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 21:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbYIWB7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 21:59:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56918
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753788AbYIWB7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 21:59:14 -0400
Date: Mon, 22 Sep 2008 18:59:02 -0700 (PDT)
Message-Id: <20080922.185902.80812984.davem@davemloft.net>
To: airlied@gmail.com
Cc: jkosina@suse.cz, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com, david.vrabel@csr.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
From: David Miller <davem@davemloft.net>
In-Reply-To: <21d7e9970809221826i76081719pdd749237580fc68e@mail.gmail.com>
References: <Pine.LNX.4.64.0809230010460.27884@twin.jikos.cz>
	<20080922.152815.22060684.davem@davemloft.net>
	<21d7e9970809221826i76081719pdd749237580fc68e@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dave Airlie" <airlied@gmail.com>
Date: Tue, 23 Sep 2008 11:26:52 +1000

> On Tue, Sep 23, 2008 at 8:28 AM, David Miller <davem@davemloft.net> wrote:
> > From: Jiri Kosina <jkosina@suse.cz>
> > Date: Tue, 23 Sep 2008 00:15:08 +0200 (CEST)
> >
> >> On Mon, 22 Sep 2008, Dave Airlie wrote:
> >>
> >> > Sep 8th I booted my own 2.6.27-rc5 kernel based from
> >> > ec0c15afb41fd9ad45b53468b60db50170e22346
> >> > This got a corrupted e1000e checksum and every kernel since has.
 ...
> It was exactly 2.6.27-rc5 + Fedora at the time but we rarely touch
> these areas, most of the extra code is in other places, and since
> people are seeing it on !Fedora
> also I would assume it wasn't these.
> 
> I think people have seen it on earlier kernels maybe but not sure.

So I went through the changes from 2.6.27-rc5 until the SHA1
ID ec0c15afb41fd9ad45b53468b60db50170e22346 and there were
definitely no E1000 or E1000E changes during that time.

Included in there is the HPET revert and other similarly themed
changes.

commit b4609472116bb806a95e98d04767189406c74c70
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Aug 29 14:38:03 2008 -0700

    Revert "x86: fix HPET regression in 2.6.26 versus 2.6.25, check hpet against BAR, v3"
    
    This reverts commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd.

Some power management related changes stand out slightly:

commit 9d3593574702ae1899e23a1535da1ac71f928042
Author: John Kacur <jkacur@gmail.com>
Date:   Tue Sep 2 14:36:13 2008 -0700

    pm_qos_requirement might sleep

and

commit 74c4633da7994eddcfcd2762a448c6889cc2b5bd
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Sep 2 14:36:11 2008 -0700

    rtc-cmos: wake again from S5

The rest of the changes in that range look completely benign.
