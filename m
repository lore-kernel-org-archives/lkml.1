Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbZC2EyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbZC2EyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 00:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZC2EyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 00:54:01 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36212 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbZC2EyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 00:54:00 -0400
Message-ID: <49CEFECE.8020008@garzik.org>
Date: Sun, 29 Mar 2009 00:53:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain> <49CD2C47.4040300@garzik.org> <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain> <49CD4DDF.3000001@garzik.org> <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <alpine.DEB.1.10.0903281726100.22577@asgard.lang.hm> <49CECDEB.7040704@garzik.org> <20090329034346.GA10984@mit.edu>
In-Reply-To: <20090329034346.GA10984@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> So having some mode where we can suspend all writes to the disk for up
> to a user-defined limit --- and then once the disk wakes up, for
> reading or for writing, we flush out all dirty data --- makes a lot of
> sense.  Laptop mode does most of this already, except that it doesn't
> intercept fsync() requests.  And as long as the user has given
> permission to the operating system to defer fsync() requests by up to
> some user-specified time limit, IMHO that's completely fair game.


Overall I agree, but I would rewrite that as:  it's fair game as long as 
the OS doesn't undercut the deliberate write ordering performed by the 
userland application.

When the "laptop mode fsync plug" is uncorked, writes should not be 
merged across an fsync(2) barrier; otherwise it becomes impossible to 
build transactional databases with any consistency guarantees at all.

	Jeff



