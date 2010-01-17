Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739Ab0AQXAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab0AQXAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 18:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231Ab0AQXAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 18:00:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41343 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198Ab0AQXAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 18:00:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: [linux-pm] Memory allocations in .suspend became very unreliable)
Date: Mon, 18 Jan 2010 00:00:23 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1263549544.3112.10.camel@maxim-laptop> <201001171427.27954.rjw@sisk.pl> <1263754684.724.444.camel@pasglop>
In-Reply-To: <1263754684.724.444.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001180000.23376.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 January 2010, Benjamin Herrenschmidt wrote:
> On Sun, 2010-01-17 at 14:27 +0100, Rafael J. Wysocki wrote:
...
> However, it's hard to deal with the case of allocations that have
> already started waiting for IOs. It might be possible to have some VM
> hook to make them wakeup, re-evaluate the situation and get out of that
> code path but in any case it would be tricky.

In the second version of the patch I used an rwsem that made us wait for these
allocations to complete before we changed gfp_allowed_mask.

[This is kinda buggy in the version I sent, but I'm going to send an update
in a minute.]

Rafael
