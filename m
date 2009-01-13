Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbZAMNT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbZAMNT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbZAMNTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:19:50 -0500
Received: from THUNK.ORG ([69.25.196.29]:54538 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbZAMNTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:19:49 -0500
Date: Tue, 13 Jan 2009 08:19:37 -0500
From: Theodore Tso <tytso@mit.edu>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Rientjes <rientjes@google.com>,
       Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090113131937.GB17664@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Evgeniy Polyakov <zbr@ioremap.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	David Rientjes <rientjes@google.com>,
	Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20090112161931.6203f96e@lxorguk.ukuu.org.uk> <20090112162938.GA22647@ioremap.net> <496BCB7A.2010804@tmr.com> <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net> <20090113121510.68a55fe9@lxorguk.ukuu.org.uk> <20090113122904.GC25011@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113122904.GC25011@ioremap.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of trying to specify which process should be protected from
the OOM killer by name, how about something which is inherited from
the parent process?  After all, if having the child not get killed due
to OOM is important, the child won't even have a chance to run if the
parent gets killed off.  And in fact, we have something that fits that
bill fairly well; getrlimit()/setrlimit().  Why not define a new
resource limit which specifies a relative immunity to the oom_killer?

Most of the infrastructure to support that will already be in place
(i.e., shell support, PAM support in /etc/securitylimits.conf); all
that would need to be done is to teach a few userspace
programs/libraries about the new resource limit.

This would be a much cleaner approach, I would think.

Regards,

						- Ted
