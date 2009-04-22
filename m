Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbZDVAbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbZDVAbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 20:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZDVAbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 20:31:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32923
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbZDVAbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 20:31:31 -0400
Date: Tue, 21 Apr 2009 17:31:23 -0700 (PDT)
Message-Id: <20090421.173123.191021055.davem@davemloft.net>
To: hpa@zytor.com
Cc: rdreier@cisco.com, h.mitake@gmail.com, mingo@elte.hu, tglx@linutronix.de,
       rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
From: David Miller <davem@davemloft.net>
In-Reply-To: <49EE37AF.4020507@zytor.com>
References: <49EE19E0.8040405@zytor.com>
	<adaocupvhid.fsf@cisco.com>
	<49EE37AF.4020507@zytor.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 21 Apr 2009 14:16:31 -0700

> Roland Dreier wrote:
>> To be honest I think the status quo ante was not really that bad.
> 
> That I have to vehemently disagree with.

I have to agree with Roland.

Unless you make it a compile failure, no driver author is going to
spend any amount of time trying to figure out how to deal with this
situation properly.

So in this sense, the current situation works really well.

If you make it just compile and make an arbitrary choice of whether
the top-32bits is read first or not, you're going to end up with
mysterious driver failures that only occur on some machines and the
cause of which won't be determined until after a lot of painful
digging.

This painful debugging experience is eliminated if the driver author
is told with a compile failure that there is an issue to resolve.

And that is what happens right now.
