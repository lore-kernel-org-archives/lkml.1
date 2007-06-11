Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbXFKPvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbXFKPvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbXFKPvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:51:25 -0400
Received: from alnrmhc14.comcast.net ([206.18.177.54]:50256 "EHLO
	alnrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbXFKPvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:51:23 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: A kexec approach to hibernation
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl>
	<87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl>
	<87k5un9l4n.fsf@jbms.ath.cx>
	<1181533248.17758.55.camel@nigel.suspend2.net>
	<87abv6o7qo.fsf@jbms.ath.cx>
	<1181576723.11365.45.camel@frg-rhel40-em64t-04>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Mon, 11 Jun 2007 11:51:21 -0400
In-Reply-To: <1181576723.11365.45.camel@frg-rhel40-em64t-04> (Xavier Bestel's
	message of "Mon\, 11 Jun 2007 17\:45\:23 +0200")
Message-ID: <87r6oimqva.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xavier Bestel <xavier.bestel@free.fr> writes:

> On Mon, 2007-06-11 at 11:01 -0400, Jeremy Maitin-Shepard wrote:
>> >> You might claim then that the solution is to simply keep the network
>> >> driver quiesced or stopped.  But then it is impossible to write the
>> >> image over the network.  The way to get around this problem is to write
>> >> the image over the network using a fresh network stack.
>> 
>> > Or teach the driver stack about the difference/reset it. Remember that
>> > even if you get a fresh network stack, you'll still be getting packets
>> > for the old stack. Getting a new ip (assuming one is available) won't
>> > stop other connections getting killed, either because we send resets
>> > from the kexec'd kernel, or because they timeout looking for the old
>> > ip.
>> 
>> I could be mistaken, but I think that bringing up the network interface
>> with a different IP address would prevent it from reseting existing TCP
>> connections, because it would never receive the packets for those
>> existing connections.  

> That can't work. There are networks where the client must have a fixed
> IP, or must accept the adress given by dhcp in order to talk to
> fileservers. And you still have the same mac adress, which may cause
> problems.

I wasn't suggesting that using a different IP address would be a general
solution.  It might be a solution for a few people.

In general, I'd imagine that most people would not bring up the network
interface at all, and most of the people that do would bring it up with
the same IP address, causing some existing TCP connections to possibly
be reset.

I think that causing connections to be reset is, however, far better
than acking packets that are then silently thrown away.

-- 
Jeremy Maitin-Shepard
