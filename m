Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbZANBUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbZANBUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 20:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbZANBUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 20:20:05 -0500
Received: from cs-studio.ru ([195.178.208.66]:53169 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449AbZANBUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 20:20:04 -0500
Date: Wed, 14 Jan 2009 04:20:01 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Theodore Tso <tytso@mit.edu>, David Rientjes <rientjes@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090114012001.GA3402@ioremap.net>
References: <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net> <20090113121510.68a55fe9@lxorguk.ukuu.org.uk> <20090113122904.GC25011@ioremap.net> <alpine.DEB.2.00.0901131116220.8522@chino.kir.corp.google.com> <20090113214627.GC27227@ioremap.net> <20090113224941.GA14730@mit.edu> <20090113230240.GA30192@ioremap.net> <20090114011137.GC14730@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114011137.GC14730@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 08:11:38PM -0500, Theodore Tso (tytso@mit.edu) wrote:
> I think you will find that most people are far more interested in
> making sure we define consistent, usable interfaces --- and depending
> on process names is a complete and total hack.  Justifying it by
> claiming that we won't be able to change application source code, so
> we have to use a hack, isn't going to get you very far.

It is not about the possibility to change the sources, but the way
interface is exported to the userspace. Right now it is not usable for
some cases. And forcing applications, which are actually cross-platform,
depending on the way linux controls its own oom-killer is noticebly more
hackish than selecting a system-wide process by its name.

> The security implications alone are troubling; OK, so we make the
> process name "sshd" privileged and exempt from the OOM killer.  What
> happens if a user creates a program called sshd in their home
> directory and executes it --- gee, it's protected from the OOM killer
> as well.  It's just not going to fly.  Give up now.

It is not about who is protected, but who will be selected to be killed.
If you have a rogue application which happend to have the right name,
everything is ok, otherwise it should be tuned further. And even in that
case nothing harmless will happen, since another processes will be
killed first (since admin selected the name on purpose to kill
potentially damaging applications).

> If your argument is "we have to protect crappy closed source
> applications where their programmers can't be bothered to change their
> source code to use a proper interface", you're just going to get
> laughed out of the room.

You believe that changing apache to control oom_adj is the right way to
deal with linux oom-killer? Do we already flight to the moon?

-- 
	Evgeniy Polyakov
