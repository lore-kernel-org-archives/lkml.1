Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbXLHRu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbXLHRu2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 12:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbXLHRuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 12:50:19 -0500
Received: from thunk.org ([69.25.196.29]:48679 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbXLHRuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 12:50:17 -0500
Date: Sat, 8 Dec 2007 12:49:08 -0500
From: Theodore Tso <tytso@mit.edu>
To: Mike McGrath <mmcgrath@redhat.com>
Cc: Jon Masters <jonathan@jonmasters.org>, Matt Mackall <mpm@selenic.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071208174908.GJ17037@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Mike McGrath <mmcgrath@redhat.com>,
	Jon Masters <jonathan@jonmasters.org>,
	Matt Mackall <mpm@selenic.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Ray Lee <ray@madrabbit.org>, Adrian Bunk <bunk@kernel.org>,
	Marc Haber <mh+linux-kernel@zugschlus.de>,
	linux-kernel@vger.kernel.org
References: <20071204210827.GE19691@waste.org> <4755C423.60907@redhat.com> <20071204221525.GG19691@waste.org> <4755D350.1080801@redhat.com> <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com> <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion> <20071208173204.GI17037@thunk.org> <475AD585.7020908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475AD585.7020908@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 11:33:57AM -0600, Mike McGrath wrote:
>> Huh?  What's the concern?  All you are submitting is a list of
>> hardware devices in your system.  That's hardly anything sensitive....
>
> We actually had a very vocal minority about all of that which ended up 
> putting us in the unfortunate position of generating a random UUID instead 
> of using a hardware UUID from hal :-/

Tinfoil hat responses indeed!  Ok, if those folks are really that
crazy, my suggestion then would be to do a "ifconfig -a > /dev/random"
before generating the UUID, and/or waiting until you just about to
send the first profile, and/or if you don't yet have a UUID,
generating it at that very moment.  The first will mix in the MAC
address into the random pool, which will help guarantee uniqueness,
and waiting until just before you send the result will mean it is much
more likely that the random pool will have collected some entropy from
user I/O, thus making the random UUID not only unique, but also
unpredictable.

						- Ted
