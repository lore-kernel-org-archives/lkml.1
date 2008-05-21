Return-Path: <linux-kernel-owner+w=401wt.eu-S934246AbYEUA4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934246AbYEUA4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760967AbYEUAzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:55:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757034AbYEUAzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:55:54 -0400
Date: Tue, 20 May 2008 17:55:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, mchehab@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] or51132.c: unaligned
In-Reply-To: <20080521004548.GD28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0805201752230.3081@woody.linux-foundation.org>
References: <E1JycGV-0004yJ-SP@ZenIV.linux.org.uk> <1211330472.5915.228.camel@brick> <20080521004548.GD28946@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 May 2008, Al Viro wrote:

> On Tue, May 20, 2008 at 05:41:12PM -0700, Harvey Harrison wrote:
> 
> > > +	return buf[0] | (buf[1] << 8);
> > 
> > return get_unaligned_le16(buf);
> 
> And the point of that would be?

Perhaps better code generation?

I didn't look what 

	buf[0] | (buf[1] << 8)

generates, but on x86, get_unaligned_le16() should just boil down to

	*(unsigned short *)buf

which is certainly going to mostly generate better code (smaller, faster) 
than at least the most likely and straigthforward of the former.

(Just checked. Gcc is not smart enough to make those two loads plus a 
shift be one word load. At least not my version)

		Linus
