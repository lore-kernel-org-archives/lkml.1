Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbYARA5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbYARA5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbYARA5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:57:08 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:4072 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbYARA5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:57:07 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <torvalds@linux-foundation.org>
Cc: "Johannes Weiner" <hannes@saeurebad.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <clameter@sgi.com>, <penberg@cs.helsinki.fi>
Subject: RE: Why is the kfree() argument const?
Date: Thu, 17 Jan 2008 16:56:02 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEIPJJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <alpine.LFD.1.00.0801171507570.2957@woody.linux-foundation.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 17 Jan 2008 16:57:15 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 17 Jan 2008 16:57:16 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Thu, 17 Jan 2008, David Schwartz wrote:

> > No, that's not what it means. It has nothing to do with memory.
> > It has to do
> > with logical state.

> Blah. That's just your own made-up explanation of what you think "const"
> should mean. It has no logical background or any basis in the C language.

To some extent, I agree. You can use "const" for pretty much any reason.
It's just a way to say that you have a pointer and you would like an error
if certain things are done with it.

You could use it to mean anything you want it to mean. The most common use,
and the one intended, is to indicate that an object's logical state will not
be changed through that pointer.

> "const" has nothing to do with "logical state".  It has one meaning, and
> one meaning only: the compiler should complain if that particular type is
> used to do a write access.

Right, exactly.

> It says nothing at all about the "logical state of the object".
> It cannot,
> since a single object can - and does - have multiple pointers to it.

You are the only one who has suggested it has anything to do with changes
through other pointers or in other ways. So you are arguing against only
yourself here.

Nobody has said it has anything to do with anything but operations through
that pointer.

> So your standpoint not only has no relevant background to it, it's also
> not even logically consistent.

Actually, that is true of your position. On the one hand, you defend it
because kfree does not change the data. On the other hand, you claim that it
has nothing to do with whether or not the data is changed.

The normal use of "const" is to indicate that the logical state of the
object should not be changed through that pointer. The 'kfree' function
changes the logical state of the object. So, logically, 'kfree' should not
be const.

The usefulness of "const" is that you get an error if you unexpectedly
modify something you weren't expected to modify. If you are 'kfree'ing an
object that is supposed to be logically immutable, you should be made to
indicate that you are aware the object is logically immutable.

Simply put, you you have to cast in any case where you mean to do something
that you want to get an error in if you do not cast. I would like to get an
error if I call 'kfree' through a const pointer, because that often is an
error. I may have a const pointer because my caller still plans to use the
object.

Honestly, I find your position bizarre.

DS


