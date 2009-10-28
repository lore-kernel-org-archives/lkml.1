Return-Path: <linux-kernel-owner+w=401wt.eu-S932472AbZJ1A7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbZJ1A7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 20:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbZJ1A7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 20:59:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45179
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757059AbZJ1A7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 20:59:16 -0400
Date: Tue, 27 Oct 2009 17:59:40 -0700 (PDT)
Message-Id: <20091027.175940.209239217.davem@davemloft.net>
To: mingo@elte.hu
Cc: lethal@linux-sh.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Kill off -Wcast-align
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091027135025.GC32628@elte.hu>
References: <20091026094729.GB13517@linux-sh.org>
	<20091026.154055.07992945.davem@davemloft.net>
	<20091027135025.GC32628@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 27 Oct 2009 14:50:25 +0100

> Generally if you run into such issues in Sparc let us know so we can fix 
> it :-)

Sorry, I wanted to do a thorough analysis to make sure I understood
why it was warning, but I was too busy to do so.

In the end the issue is the kernel list.h macros like list_entry(),
and it would similarly trigger for things like container_of().

If you have a pointer to a structure with objects other than "long
double" then cast it to a pointer to a structure that does have a
"long double" in it, this increases the alignment of the type (from 8
to 16 bytes on sparc 32-bit).
