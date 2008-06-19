Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbYFSEAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbYFSEAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 00:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYFSD7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 23:59:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50769
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752422AbYFSD7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 23:59:48 -0400
Date: Wed, 18 Jun 2008 20:59:48 -0700 (PDT)
Message-Id: <20080618.205948.107681537.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0806182318170.27388@engineering.redhat.com>
References: <Pine.LNX.4.64.0806171954060.2560@engineering.redhat.com>
	<20080617.210159.141238856.davem@davemloft.net>
	<Pine.LNX.4.64.0806182318170.27388@engineering.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Wed, 18 Jun 2008 23:24:20 -0400 (EDT)

> BTW. what's the purpose of having 192-byte stack frame? There are 16 
> 8-byte registers being saved per function call, so 128-byte frame should 
> be sufficient, shoudn't? The ABI specifies that some additional entries 
> must be present even if unused, but I don't see reason for them. Would 
> something bad happen if GCC started to generate 128-byte stacks?

The callee can pop the arguments into the area past the
register window.

So you have the 128 byte register window save area, 6
slots for incoming arguments, which gives us 176 bytes.
The rest is for some miscellaneous stack frame state,
which I don't remember the details of at the moment.
I'd have to read the sparc backend of gcc to remember.
