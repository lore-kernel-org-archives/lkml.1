Return-Path: <linux-kernel-owner+w=401wt.eu-S932530AbYGQUBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530AbYGQUBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbYGQUB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:01:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752880AbYGQUB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:01:26 -0400
Date: Thu, 17 Jul 2008 13:01:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Ray Lee <ray-lk@madrabbit.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, torvalds@linuxfoundation.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
In-Reply-To: <487FA24B.9060803@firstfloor.org>
Message-ID: <alpine.LFD.1.10.0807171259010.2959@woody.linux-foundation.org>
References: <20080716214516.GA10777@basil.nowhere.org>  <200807170011.12184.rjw@sisk.pl>  <200807161633.01375.jbarnes@virtuousgeek.org>  <487EEAEB.4050009@firstfloor.org>  <alpine.LFD.1.10.0807170807040.2959@woody.linux-foundation.org> 
 <alpine.LFD.1.10.0807170835320.2959@woody.linux-foundation.org>  <487F71E8.9050705@firstfloor.org> <2c0942db0807171211s39e2653fwdc50f92d9c3020d2@mail.gmail.com> <487FA24B.9060803@firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 17 Jul 2008, Andi Kleen wrote:
> 
> The whole point of the exercise of cleaning up/rewriting the history is to make
> the tree as bisectable as possible.

No.

"git bisect" is perfetly able to handle merges. They are _fine_.

The problem with rebasing is that it *changes* something that was already 
tested (and possibly merged into somebody elses tree) into SOMETHING ELSE.

And that means that a large portion of the previous testing is basically 
thrown away.

In particular, if something worked for somebody before, it also removes 
the "known good state" from a bisection standpoint, so rebasing actually 
makes things _harder_ to bisect - because now you cannot sanely bisect 
between two versions of the tree (when you mark the old tree "good", it 
has no relevance to the new tree that had all the old history rewritten).

So no, rebasing does _not_ make bisection easier. It makes it easier to 
understand, perhaps, but it actually makes many things much much harder, 
and removes all trace of any testing coverage that the old commit had.

			Linus
