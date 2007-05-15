Return-Path: <linux-kernel-owner+w=401wt.eu-S1761464AbXEOCsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464AbXEOCsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 22:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbXEOCsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 22:48:01 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4104 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694AbXEOCsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 22:48:00 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: undeprecate raw driver.
Date: Mon, 14 May 2007 19:47:34 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKCENKDMAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <Pine.LNX.4.64.0705140957370.12444@localhost.localdomain>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 14 May 2007 20:47:55 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 14 May 2007 20:47:57 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Mon, 14 May 2007, Bob Johnston wrote:

> > Alan Cox <alan <at> lxorguk.ukuu.org.uk> writes:
> >
> > > > Why not just use the terms:
> > > > * outdated - as a replacement for "deprecated".
> > >
> > > Because they don't actually mean the same thing ?
> >
> > "superseded" would probably be a better word, perhaps lacking the
> > negative connotations of "deprecated"

> except that you *want* the negative connotation associated with the
> word "deprecated."  you don't just want to say something's been
> superseded.  rather, you want to say that it's not only been
> superseded but that you really want people to *stop using it* and move
> up to the newer version; otherwise, there is no motivation to upgrade.

> i'm just baffled by the resistance to the word "deprecated" since it
> represents *exactly* the idea you want to get across here.  its use
> in software projects is well-established.  why are some people so put
> off by it?

Let me give this a big AOL-style "me too". Terms such as "deprecated" and
"obsolete" have been used by programmers for as long as I can remember, and
if you don't know exactly what they mean, you probably should just learn.

A feature is "deprecated" if there is some other feature or mechanism that
is considered superior to it in all cases. It may just be more efficient, it
may avoid potential pitfalls of the deprecated mechanism.

You should avoid using a deprecated feature in new code and should try to
remove use of it from old code. The classic example of a deprecated function
is 'gets'. Deprecated features are generally kept for compatability purposes
or because standards require them. A function deprecated on one platform may
be perfectly fine on another.

You might choose to use a deprecated feature for compatability purposes. It
is not urgent to hack use of deprecated features out of existing code.
(However, you should evaluate whether the reason for deprecation creates a
problem in your code, especially if it's a security issue.)

Deprecated features can reasonably be expected to continue to work as well
as they ever have. They should not be newly-broken. If a deprecated feature
is broken in a new version, that is a regression.

A feature is "obsolete" if it no longer serves any purpose. It may be so
broken that it is no longer even usable. It might still be technically
working but not have any actual case of any significance in which you might
want to use it. Linux's Sony CDU-535 driver is obsolete (a driver for an old
CDROM drive with a specialized ISA controller that transferred data at well
less than 1X and supports only a *very* slow PIO mode).

Obsolete features are generally scheduled for removal. They are usually not
removed just on the off chance that the removal might harm someone. It may
not even be possible to test them and the last time they were tested may
have been several major releases ago. One should generally not expect
obsolete features to work.

Something obsolete may conflict with never features. For example, a driver
that breaks with hotpluggable CPUs. One contemplating using an obsolete
feature in a new design should have a damn good reason and might possibly
need to have their head examined.

The raw driver *is* deprecated. It is *not* obsolete.

DS


