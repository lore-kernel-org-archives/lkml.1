Return-Path: <linux-kernel-owner+w=401wt.eu-S932520AbZHVJaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbZHVJaR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 05:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbZHVJaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 05:30:16 -0400
Received: from ppp-137-74.adsl.restena.lu ([158.64.137.74]:60494 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbZHVJaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 05:30:15 -0400
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Aug 2009 05:30:15 EDT
Date: Sat, 22 Aug 2009 11:21:03 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andy Whitcroft <apw@canonical.com>, "Ed L. Cashin" <ecashin@coraid.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] aoe: ensure we initialise the request_queue
 correctly
Message-ID: <20090822112103.49174d6b@neptune.home>
In-Reply-To: <1250872904-10993-1-git-send-email-apw@canonical.com>
References: <1250872904-10993-1-git-send-email-apw@canonical.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael, this matches regression bug #13942 "Troubles with AoE and
uninitialized object".

Will test and report how it works out here.

Bruno


On Fri, 21 August 2009 Andy Whitcroft <apw@canonical.com> wrote:
> We have been seeing oopses in very recent kernels when using the AOE
> driver. When attempting to mount remote devices we get a warning from
> the kobject layer:
> 
>   [ 2645.959090] kobject '<NULL>' (ffff880059ca22c0): tried to add
> 	an uninitialized object, something is seriously wrong.
> 
> Looking at the driver it seems to have always had an embedded
> request_queue and it is this that is throwing the error.  It appears
> the intent is tha these would be allocated and released using
> helpers, and the lack of these leaves the object uninitialised and
> throws the error.  It is unclear how this could ever have worked.
> Anyhow the following email contains a patch to allocate and release
> this request_queue via the standard helpers. This has bene shown to
> fix the issue in testing.
> 
> Comments.
> 
> -apw
> 
> Andy Whitcroft (1):
>   aoe: ensure we initialise the request_queue correctly
> 
>  drivers/block/aoe/aoe.h    |    2 +-
>  drivers/block/aoe/aoeblk.c |    6 +++---
>  drivers/block/aoe/aoedev.c |   11 ++++++++++-
>  3 files changed, 14 insertions(+), 5 deletions(-)
