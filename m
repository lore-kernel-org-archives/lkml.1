Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab0CEPZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:25:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59373
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675Ab0CEPZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:25:53 -0500
Date: Fri, 05 Mar 2010 07:26:12 -0800 (PST)
Message-Id: <20100305.072612.186421758.davem@davemloft.net>
To: daniel@fooishbar.org
Cc: alan@lxorguk.ukuu.org.uk, skeggsb@gmail.com, airlied@linux.ie,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       dri-devel@lists.sf.net, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: [git pull] drm request 3
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100305151754.GB2505@tempa>
References: <20100305123834.0d9c6277@lxorguk.ukuu.org.uk>
	<20100305.063718.211238119.davem@davemloft.net>
	<20100305151754.GB2505@tempa>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Stone <daniel@fooishbar.org>
Date: Fri, 5 Mar 2010 17:17:54 +0200

> On Fri, Mar 05, 2010 at 06:37:18AM -0800, David Miller wrote:
>> If it effects such a large number of people, which this noveau thing
>> does, it's entirely relevant to everyone.  And the way it's breaking
>> and making kernel development difficult for so many people matters to
>> us.
> 
> Maybe the lesson to be learned from all this is, 'if the developers
> don't want something merged because they're not ready and forsee huge
> problems in the future, actually listen to them instead of blindly
> ramming it in regardless'? But maybe that's just me.

That's doesn't work, and it never will.

First of all, if we didn't merge the driver Fedora users wouldn't be
able to test the upstream kernel at all.

And if you think things through, there is one and onle one set of
actions that would have made things work properly.

And that's merge the driver upstream and not break user visible APIs.

In fact, I argue that the moment nouveau went into Fedora and
was turned on by default, the interfaces needed to be frozen.

Consider if it didn't go upstream and I want to do upstream
kernel development, ok so I patch the noveau-of-the-moment into
my upstream tree.

Six months and 10 DRM library updates later I go back and try to boot
that kernel.  And it's not going to work.

So if the user visible APIs are changed in any set of situations
(upstream merged, not upstream merged, etc.) things can end up
breaking.

Ergo, you simply can't sanely do it at all.  You have to have
a compatability story when you change these things.

Personally I wouldn't have ever committed to that "user visible APIs
can break cause it's in -stable."  Because that's complete garbage.

