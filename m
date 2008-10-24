Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbYJXWPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbYJXWPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 18:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbYJXWPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 18:15:46 -0400
Received: from styx.suse.cz ([82.119.242.94]:50520 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755125AbYJXWPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 18:15:46 -0400
Date: Sat, 25 Oct 2008 00:15:44 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Matt Mackall <mpm@selenic.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: Bloatwatch 2.6.28-rc1: i8042 DMI lookup tables
In-Reply-To: <1224879959.3248.32.camel@calx>
Message-ID: <alpine.LNX.1.10.0810250001530.27479@jikos.suse.cz>
References: <1224879959.3248.32.camel@calx>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008, Matt Mackall wrote:

> We've added 12k of new initdata to allnoconfig builds for i8042 DMI
> lookup tables:
> 
> http://www.selenic.com/bloatwatch/?cmd=compare;v1=2.6.27;v2=2.6.28-rc1;part=/built-in/drivers
> 
> It looks like each table entry is > 320 bytes as we reserve four 80-byte
> slots in each for DMI match strings. 

Umm, and what is the actual problem with that, really?

OK, we can remove it from .init, but then it will be rotting in memory 
forever, which is quite sub-optimal, when this kind of DMI information is 
needed only during initialization.

We can make ->ident strings shorter, they do not serve any real purpose, 
and are there just for readability. Is it worth that?

We can make a config option which will guard existence of these lists, 
such as CONFIG_INPUT_BLACKLISTS, let id default to y and depend on 
EMBEDDED.

Any other reasonable ideas?

-- 
Jiri Kosina
SUSE Labs
