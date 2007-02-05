Return-Path: <linux-kernel-owner+w=401wt.eu-S933452AbXBEVSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452AbXBEVSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:18:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933457AbXBEVSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:18:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57855 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452AbXBEVSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:18:10 -0500
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	 <20070205084523.GA21858@elte.hu>
	 <1170682488.29759.795.camel@pmac.infradead.org>
	 <20070205155627.GA8354@elte.hu>
	 <1170692539.29759.856.camel@pmac.infradead.org>
	 <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu>
	 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 05 Feb 2007 21:17:52 +0000
Message-Id: <1170710272.29759.894.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 08:58 -0800, Linus Torvalds wrote:
> More importantly, some things that *are* visible probably shouldn't be, or 
> should perhaps only be in expert mode (aka "EMBEDDED").

I've heard some fairly stupid abuse of the term 'embedded' in my time,
but rarely have I heard people daft enough to abuse it to mean 'expert'.
But yes, that's what we use CONFIG_EMBEDDED for.

> A prime example of this is all the firewall settings. I'd personally 
> prefer to just select a "default firewall setup" which would be enough 
> for all the normal crud, instead of seeing 50 different choices. 

No, that's a really poor example. That's not what 'select' is for. We
can handle that kind of thing perfectly well without select -- just with
sensible _defaults_, much as we do for block device partitions and a few
other  things.

> Me, I'd like to say I want "default firewall built in", and not have to 
> see *any* of the crap. And that's exactly why "select" is a good thing.
> 
> Not using select, and have people having to say "y" to the basic feature 
> and then y/m/n to each sub-feature is really damn annoying.

No, you're thinking of something else. The use of 'select' just turns
the problem backwards -- if _every_ SCSI hostadapter were to 'select
SCSI' instead of depending on it, then I'd have to say 'n' to every damn
one of them instead of being able to just say 'n' to SCSI as I can at
the moment.

Well, I say 'just turns it backwards', but in fact it also makes it much
worse, because it's now much _harder_ to turn SCSI off, because there
might be random stuff else elsewhere in the tree which selects it rather
than having all the dependencies right on the option I'm interested in,
where I can see them and turn them on/off as required.

The dependency thing for Aunt Tillie is easily fixed in the tools, and
the firewall example you're thinking of is _far_ from being an example
of why 'select' is useful.

-- 
dwmw2

