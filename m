Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbYAHXU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbYAHXU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbYAHXUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:20:18 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56622 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751497AbYAHXUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:20:16 -0500
Date: Tue, 8 Jan 2008 17:20:15 -0600 (CST)
From: Brent Casavant <bcasavan@sgi.com>
Reply-To: Brent Casavant <bcasavan@sgi.com>
To: Rick Jones <rick.jones2@hp.com>
cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: AF_UNIX MSG_PEEK bug?
In-Reply-To: <4783FBD6.1000004@hp.com>
Message-ID: <alpine.BSF.1.00.0801081702370.24286@pkunk.americas.sgi.com>
References: <alpine.BSF.1.00.0801081556580.24286@pkunk.americas.sgi.com> <4783FBD6.1000004@hp.com>
User-Agent: Alpine 1.00 (BSF 882 2007-12-20)
Organization: "Silicon Graphics, Inc."
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008, Rick Jones wrote:

> Potential bugs notwithstanding, given that this is a STREAM socket, and as
> such shouldn't (I hope, or I'm eating toes for dinner again) have side effects
> like tossing the rest of a datagram, why are you using MSG_PEEK?  Why not
> simply read the N bytes of the message that will have the message length with
> a normal read/recv, and then read that many bytes in the next call?

That's entirely reasonable, and probably a worthwhile change to make.
But, as you say, it doesn't change whether or not this is a bug in
the MSG_PEEK code.

With a small bit of complication I certainly can do what you suggest.

The initial reasoning was that this made it easy to handle the case where
the caller of the library routine (my code which stumbled on this was
part of a small library I wrote as part of the application) did not supply
a sufficiently sized buffer for reception of the next message.  The "easy"
way to do this was a MSG_PEEK to validate the buffer size against the
message size, followed by a regular recv() if the buffer is large enough.
To do what you suggest (which effectively works around the bug) is certainly
possible, but also requires maintaining state between calls to the
"get message" routine, as I need to track whether or not the size has already
been read from the next message on the stream socket.

The change isn't terribly difficult, but wasn't the initial idea.

Plus it's always good to flush a bug out of hiding, right? ;)

Brent

-- 
Brent Casavant                          All music is folk music.  I ain't
bcasavan@sgi.com                        never heard a horse sing a song.
Silicon Graphics, Inc.                    -- Louis Armstrong
