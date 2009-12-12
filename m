Return-Path: <linux-kernel-owner+w=401wt.eu-S932555AbZLLFrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbZLLFrJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 00:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758201AbZLLFrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 00:47:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56516
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758095AbZLLFrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 00:47:08 -0500
Date: Fri, 11 Dec 2009 21:47:14 -0800 (PST)
Message-Id: <20091211.214714.41966763.davem@davemloft.net>
To: gregkh@suse.de
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: usb_autopm_*() removal build failure...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091212040524.GA11212@suse.de>
References: <20091211.174551.123151540.davem@davemloft.net>
	<20091212040524.GA11212@suse.de>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Fri, 11 Dec 2009 20:05:24 -0800

> Here's the patch, sent back in August:
> 	 http://marc.info/?l=linux-netdev&m=125071045301270&w=2
> 
> Can you take it from there, or do you need me to forward it on?

I tossed this into the net-2.6 tree, but...

I would recommend that in the future when you have the
dependency of an API change that's going to break the
build, you take in the necessary change.  And you make
sure such a commit is in your tree before the commit
that removes the API.

That posting had all the markings of something that wasn't
my business applying:

1) the subject said "usb" and nothing about networking or
   a specific networking driver

2) it was resolving an API issue introduced by another tree

This also means you weren't doing allmodconfig builds on your USB tree
this entire time, because if you had you would have realized that this
fix belonged there not in net-2.6 :-)  And if the USB bits were
going in via -next I'm really surprised Stephen Rothwell wasn't
complaining about this too :)

Anyways, next time, please resolve API issues internally when you
do things that will break the build otherwise.

We can merge it all together during the merge window just fine.

Thanks!


