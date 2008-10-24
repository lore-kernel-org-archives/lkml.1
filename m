Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbYJXXOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbYJXXOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbYJXXN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:13:58 -0400
Received: from waste.org ([66.93.16.53]:59887 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbYJXXN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:13:57 -0400
Subject: Re: Bloatwatch 2.6.28-rc1: i8042 DMI lookup tables
From: Matt Mackall <mpm@selenic.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <alpine.LNX.1.10.0810250001530.27479@jikos.suse.cz>
References: <1224879959.3248.32.camel@calx>
	 <alpine.LNX.1.10.0810250001530.27479@jikos.suse.cz>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 18:13:22 -0500
Message-Id: <1224890002.3248.71.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-25 at 00:15 +0200, Jiri Kosina wrote:
> On Fri, 24 Oct 2008, Matt Mackall wrote:
> 
> > We've added 12k of new initdata to allnoconfig builds for i8042 DMI
> > lookup tables:
> > 
> > http://www.selenic.com/bloatwatch/?cmd=compare;v1=2.6.27;v2=2.6.28-rc1;part=/built-in/drivers
> > 
> > It looks like each table entry is > 320 bytes as we reserve four 80-byte
> > slots in each for DMI match strings. 
> 
> Umm, and what is the actual problem with that, really?

The actual problem is that if the kernel grows by 12k every time a
developer says "what's the big deal?" the kernel will become very large
indeed.

> OK, we can remove it from .init, but then it will be rotting in memory 
> forever, which is quite sub-optimal, when this kind of DMI information is 
> needed only during initialization.

I wasn't complaining that they were in init, but rather that they were
12k. For something like 37 entries. The entry size is ridiculous and
looks to have grown by a factor of 10 since 2.6.27. What, as they say,
is up with that?

It looks like David Woodhouse is to blame:

commit d945b697d0eea5a811ec299c5f1a25889bb0242b
Automatic MODULE_ALIAS() for DMI match tables.

This is probably also responsible for most of the growth in x86 I
mentioned elsewhere, so it's about 25-30k damage in total. David?

-- 
Mathematics is the supreme nostalgia of our time.

