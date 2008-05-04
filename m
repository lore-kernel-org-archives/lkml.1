Return-Path: <linux-kernel-owner+w=401wt.eu-S1757158AbYEDM5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbYEDM5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 08:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYEDM5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 08:57:15 -0400
Received: from brmea-mail-3.Sun.COM ([192.18.98.34]:39104 "EHLO
	brmea-mail-3.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYEDM5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 08:57:11 -0400
Date: Sun, 04 May 2008 08:55:12 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Re: kconfig - a suggestion how to fix the select issue
In-reply-to: <20080504071041.GA15315@uranus.ravnborg.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Reply-to: davecb@sun.com
Message-id: <481DB230.30907@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <20080504071041.GA15315@uranus.ravnborg.org>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
[Snipped]
> The suggestion is to introduce a "require" term used
> like this:
> 
> config A
>         bool "a"
> 
> config B
>         bool "b"
>         depends on A
> 
> config C
>         bool "c"
>         require B
> 
> The require dependency will have impact on visibility.
> C shall only be visible if all symbols it require are
> visible. Note that visible does not imply 'chosen'.
> In this case C would be visible when A is chosen.
> 
> When the user then choose C and B is not chosen 
> then the user is prompted to choose B.
> 
> So user has to chose B in order to have C chosen.
> 
> This would make it visible for the user that choosing
> a camera had the side-effect that USB had to be enabled too.
> But if we have some general option that prevents the
> visibility of USB we would not be offered the camara
> in the first place

In the example you suggest, the user would not see the
option of choosing the camera at C unless they selected
USB at A, and would wonder where the camera disappeared
to...

I speculate that having two ways to express a dependency,
and the addtition of visibility control makes the
dependency tree-walk into a problem which is no longer
solvable in trivial logic. That in turn makes my head 
explode (;-))

I wonder if one could simplify back into a flat set of
selections without visibility rules and a backwards-
chaining "you need to select these too" message emitter,
and if that would be worthwhile.

--dave (who used to do formal logics) c-b
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
(905) 943-1983, cell: (647) 833-9377, (800) 555-9786 x56583
bridge: (877) 385-4099 code: 506 9191#
