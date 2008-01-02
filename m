Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbYABFZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbYABFZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 00:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYABFZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 00:25:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53982
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752249AbYABFZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 00:25:01 -0500
Date: Tue, 01 Jan 2008 21:25:01 -0800 (PST)
Message-Id: <20080101.212501.00751091.davem@davemloft.net>
To: gregkh@suse.de
Cc: hidave.darkstar@gmail.com, greg@kroah.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080102051828.GA24431@suse.de>
References: <20071229170730.GA1351@kroah.com>
	<a8e1da0801011654j1427d466m3971f693f0439954@mail.gmail.com>
	<20080102051828.GA24431@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Tue, 1 Jan 2008 21:18:28 -0800

> But is the usage of this semaphore in the class code really a problem?
> Has it been seen to cause issues anywhere?  Does it show up on any
> benchmarks as being something that really needs to be replaced?

It's a question of maintainability and simplicity also Greg.

I actually have no idea why you're making any sort of fuss about this.
To me it's so clear cut that we should do that.

Mutexes provide a much simpler locking technology.  The things that
semaphores can do that mutexes can't are rarely if ever used.

Therefore it's better to convert all of those cases only using the
simpler semantic set of mutexes from semaphores.

And we've been converting the entire tree this way for about 2 years,
I'm sorry that you've only just noticed that this is happening and
that there is general agreement that in general all such conversions
should be made.
