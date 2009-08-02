Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbZHBN33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbZHBN33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZHBN32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:29:28 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:43989 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbZHBN31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:29:27 -0400
Date: Sun, 2 Aug 2009 09:26:48 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: any remaining interest in a Kbuild "maturity" level?
Message-ID: <alpine.LFD.2.00.0908020915270.2821@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  every few months or so, i wonder again if there's sufficient
interest in implementing a Kbuild "maturity" level to allow a kernel
builder to conveniently select or de-select kernel features of varying
levels of maturity.

  that was all covered here a while back:

    http://kerneltrap.org/node/7593

in a nutshell, i think there's considerable value in adding a new
Kconfig directive, "maturity", which would have values like:

config FUBAR
	maturity DEPRECATED
        or
        maturity OBSOLETE

where "maturity" describes the position along the life cycle of some
feature -- anywhere from, say, BLEEDING_EDGE to EXPERIMENTAL all the
way over to OBSOLETE, in much the same way EXPERIMENTAL is used now,
but not as a simple dependency since that's just plain hacky.  i think
it makes more sense to introduce a whole new "attribute" for that,
that would allow the user to, in short order, specify that he wanted
to build a new kernel but not use any features that were, say,
OBSOLETE or DEPRECATED.

  the additional convenience of this new attribute means that, when
you're configuring a kernel, you can have a "non-normal" maturity
level automatically printed next to the option, so you can immediately
see what is currently DEPRECATED or OBSOLETE, as opposed to the messy
way it's done now, where config options and their EXPERIMENTAL-ness
have a bad habit of getting out of sync, as you see here in
crypto/Kconfig:

config CRYPTO_XCBC
        tristate "XCBC support"
        depends on EXPERIMENTAL

as you can see, there's a mismatch between what's printed and the fact
that that config variable is EXPERIMENTAL, and that sort of mismatch
happens fairly frequently.

  i don't think this would be all that hard to implement, and it
wouldn't be very disruptive -- the new directive could be added but,
until it's used, it would have no effect whatever.

  thoughts?  or should i just forget this idea?

rday
--



========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
"Kernel Newbie Corner" column @ linux.com:          http://cli.gs/WG6WYX
========================================================================
