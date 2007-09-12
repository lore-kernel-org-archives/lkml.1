Return-Path: <linux-kernel-owner+w=401wt.eu-S968516AbXILOI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968516AbXILOI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 10:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966091AbXILOIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 10:08:49 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58123 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966005AbXILOIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 10:08:48 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 12 Sep 2007 10:06:35 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: David Newall <david@davidnewall.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stripping down the kernel-parameters.txt file
In-Reply-To: <46E7EA62.5020604@davidnewall.com>
Message-ID: <Pine.LNX.4.64.0709120951280.22891@localhost.localdomain>
References: <Pine.LNX.4.64.0709120339470.26177@localhost.localdomain>
 <46E7DEF8.50201@davidnewall.com> <Pine.LNX.4.64.0709120904130.20693@localhost.localdomain>
 <46E7EA62.5020604@davidnewall.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007, David Newall wrote:

> Robert P. J. Day wrote:
> > if the goal is to simply put all of the basic boot-time kernel parms
> > along with the module-specific ones into a single file, sorted in
> > alphabetical order, then i contend that this is, in fact, "silly".
>
> Or even, "messy".  There's no doubt that it should be maintained
> with care; perhaps it would if the people who write the code for
> each parameter also update the documentation.

  or (and here's a wild and crazy idea) what about writing a utility
that auto-generates all that information?

  the biggest hassle in keeping all the documentation up to date is
that much of it is being stored in a manually-updated text file
(MAINTAINERS leaps to mind), so *of course* it's always going to be
out of date.  so why not just fix it so it's auto-generated, the same
way the in-kernel nano-doc stuff is?

  surely, it wouldn't be that hard, at least for the basic parms.  a
combination of egrep, sed and sort would certainly give you the basic
parms.  off the top of my head:

$ egrep '(__setup|early_param)' $(find . -name *.c) | \
> sed -e 's/.*"\(.*\)".*/\1/' | \
> sort -u
$

  of course that's not sufficient, but it took me all of two minutes.
would it be that much work to extend it and deal with once and for
all?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
