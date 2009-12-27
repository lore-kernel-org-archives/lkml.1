Return-Path: <linux-kernel-owner+w=401wt.eu-S1751126AbZL0XeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126AbZL0XeL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 18:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbZL0XeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 18:34:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43350 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZL0XeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 18:34:09 -0500
Date: Mon, 28 Dec 2009 00:34:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH] [3/6] kfifo: Sanitize *_user error handling
Message-ID: <20091227233405.GA2399@basil.fritz.box>
References: <200912271003.631128760@firstfloor.org> <20091227210313.A8E7BB17C3@basil.firstfloor.org> <1261949880.25298.21.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261949880.25298.21.camel@wall-e>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't like this idea. kfifo_from_user and kfifo_to_user should have
> the same semantics as copy_from_user and copy_to_user. 

Maybe they should have, but the big difference is that the source
FIFO might not have enough data. And both conditions need
to be reported, but not mixed together.

The actual reporting of the unused length is not
too useful anyways. It's only used very rarely for real
c*u(), and these cases are usually misdesigned interfaces.

> > I didn't fully adapt the weird "record" variants, those seem 
> > to be unused anyways and were rather messy (should they be just removed?)
> > 
> 
> Believe it or not, it will be used in future. 

Normally in Linux code is only added when it's actually used.
Otherwise it'll bitrot anyways.

-Andi
