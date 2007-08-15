Return-Path: <linux-kernel-owner+w=401wt.eu-S1763648AbXHOOHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763648AbXHOOHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756967AbXHOOGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:06:52 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59686 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029AbXHOOGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:06:51 -0400
Date: Wed, 15 Aug 2007 16:06:49 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Rene Herman <rene.herman@gmail.com>,
       Jason Uhlenkott <jasonuhl@jasonuhl.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
In-Reply-To: <5D056606-6284-4331-98DB-77123816D5B8@mac.com>
Message-ID: <Pine.LNX.4.64.0708151604360.15707@fbirervta.pbzchgretzou.qr>
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org>
 <20070814232107.GA4265@aurum.uhlenkott.net>
 <Pine.LNX.4.64.0708150928200.19270@fbirervta.pbzchgretzou.qr>
 <46C2BB60.6010909@gmail.com> <Pine.LNX.4.64.0708151113410.19270@fbirervta.pbzchgretzou.qr>
 <46C2CE42.4010303@gmail.com> <Pine.LNX.4.64.0708151217120.5639@fbirervta.pbzchgretzou.qr>
 <5D056606-6284-4331-98DB-77123816D5B8@mac.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 15 2007 09:58, Kyle Moffett wrote:
>
> Irrespective of whatever the standard says, EVERY platform and
> compiler anybody makes nowadays has a NULL pointer value with all
> bits clear.  Theoretically the standard allows otherwise, but such
> a decision would break so much code.  Linux especially, we rely on
> the uninitialized data to have all bits clear and we depend on that
> producing NULL pointers; if a NULL pointer was not bitwise exactly
> 0 then the test "if (some_ptr != NULL)" would fail and we would
> start dereferencing garbage.

But if kmalloc returns NULL on failure, then testing for NULL
(irrespective of being 0 or 0xDEADBEEF) is ok.
What would actually concern me then is what "if (!some_ptr)" would do.
Probably not the right thing.


	Jan
-- 
