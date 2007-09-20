Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbXITWG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbXITWG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 18:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbXITWGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 18:06:49 -0400
Received: from waste.org ([66.93.16.53]:37522 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbXITWGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 18:06:48 -0400
Date: Thu, 20 Sep 2007 17:06:05 -0500
From: Matt Mackall <mpm@selenic.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
Message-ID: <20070920220604.GA17536@waste.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 11:42:29AM +1000, Dave Airlie wrote:
> > The code is broken anyways. If you free pages without flushing
> > them first some other innocent user allocating them will end up
> > with possible uncached pages for some time.
> >
> > Does this simple patch help?
> >
> 
> I've attached a more complicated patch that does a 2 stage effort to
> unmapping and freeing pages. My kernel no longer hangs with this
> patch...
> 
> Jiri can you confirm?

It's broken for me.

2.6.23-rc3-mm1: solid lock on X shutdown (noticed when upgrading)
      -rc4-mm1: solid lock on X shutdown, random solid locks about
                once every four hours
      -rc6-mm1: solid lock on X startup
   +your patch: screen goes black, turns off and on a few times during
                startup, can reboot with sysrq-b

Video is:

01:00.0 VGA compatible controller: ATI Technologies Inc Radeon R250
[Mobility FireGL 9000] (rev 02)


-- 
Mathematics is the supreme nostalgia of our time.
