Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbYFTW27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbYFTW27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 18:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbYFTW2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 18:28:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45790
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751037AbYFTW2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 18:28:48 -0400
Date: Fri, 20 Jun 2008 15:28:47 -0700 (PDT)
Message-Id: <20080620.152847.169209890.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0806201819430.25997@engineering.redhat.com>
References: <20080620.144424.168785883.davem@davemloft.net>
	<20080620.144736.224107106.davem@davemloft.net>
	<Pine.LNX.4.64.0806201819430.25997@engineering.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Fri, 20 Jun 2008 18:22:33 -0400 (EDT)

> On Fri, 20 Jun 2008, David Miller wrote:
> 
> > From: David Miller <davem@davemloft.net>
> > Date: Fri, 20 Jun 2008 14:44:24 -0700 (PDT)
> >
> >> I agree on both counts.  Although I'm curious what the average stack
> >> frame sizes look like on x86_64 and i386, and also how this area
> >> appears on powerpc.
> >
> > I also one to mention in passing that another thing we can do to
> > help deep call stack sizes is to make call chains more tail-call
> > friendly when possible.
> 
> ... and remove -fno-optimize-sibling-calls?:
> 
> Makefile:
> ifdef CONFIG_FRAME_POINTER
> KBUILD_CFLAGS   += -fno-omit-frame-pointer -fno-optimize-sibling-calls
> else
> KBUILD_CFLAGS   += -fomit-frame-pointer
> endif
> 
> --- maybe it could be better to remove it, instead of some inlining that I 
> made. Or do you see a situation when for debugging purpose, user would 
> want -fno-optimize-sibling-calls?

Yes for debugging and other things it has to stay.
