Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbYGaQ0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbYGaQ0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYGaQ0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:26:24 -0400
Received: from mail.free-electrons.com ([88.191.46.45]:36494 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbYGaQ0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:26:23 -0400
Date: Thu, 31 Jul 2008 18:26:16 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       matthew@wil.cx, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 2/4] Configure out file locking features
Message-ID: <20080731182616.4c20f0db@surf>
In-Reply-To: <20080731153757.GB20212@cs181140183.pp.htv.fi>
References: <20080731092703.661994657@free-electrons.com>
	<20080731093220.969460336@free-electrons.com>
	<20080731135319.GA20212@cs181140183.pp.htv.fi>
	<20080731162007.285938e0@surf>
	<20080731153757.GB20212@cs181140183.pp.htv.fi>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Thu, 31 Jul 2008 18:37:57 +0300,
Adrian Bunk <bunk@kernel.org> a écrit :

> I'm just not a fan of adding config options for each few kB of code - 
> we have to maintain them and the more complex the configuration
> becomes the more often it breaks.

I'm not a fan of these too, but are there other solutions ?

> What became bigger was most likely not related to the patches you
> sent.

No, it is not.

> Where and why did the kernel become bigger?

It's not up-to-date with 2.6.26 and 2.6.27-rc1, but Bloatwatch
<http://www.selenic.com/bloatwatch/>, by Matt Mackall, is here to
answer these questions. I haven't made the analysis for
2.6.26->2.6.27-rc1.

> Why did CONFIG_FW_LOADER get enabled?
> Due to alnoconfig disabling CONFIG_EMBEDDED?

I don't know. Haven't made the analysis for now.

> A user will ask:
> I'm using $applications with $libraries, can I safely disable this
> option?

Hard to tell in the general case.

> And e.g. according to a quick grep through the sources uClibc's 
> updwtmp() seems to cease working without flock().

Correct. But on many embedded systems, we don't care about logging past
user logins. We might even not care about logins at all.

> It costs us maintainance of the option and the #ifdef's and gives
> users one way more to shoot themselves into the foot in nontrivial to
> detect ways.

That's correct, and as I said previously, I fully understand the
maintainance problem of all these new configuration options. I must
admit that I do not really have more objective technical arguments that
would help us deciding whether the code size reduction vs. code
maintainance choice should be made in one direction or the other.

Sincerly,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
