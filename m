Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbXJZRzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbXJZRzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbXJZRzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:55:44 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:60636 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbXJZRzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:55:43 -0400
X-Greylist: delayed 944 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2007 13:55:43 EDT
Message-ID: <4722265C.7050907@nortel.com>
Date: Fri, 26 Oct 2007 11:39:40 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Haley <aph@redhat.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, davids@webmaster.com,
       "Torvalds, Linus" <torvalds@linux-foundation.org>,
       "Kleen, Andi" <ak@suse.de>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Is gcc thread-unsafe?
References: <MDEHLPKNGKAHNMBLJOLKMEEDHMAC.davids@webmaster.com> <200710260922.54428.nickpiggin@yahoo.com.au> <18209.54926.290448.957962@zebedee.pink>
In-Reply-To: <18209.54926.290448.957962@zebedee.pink>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Oct 2007 17:39:44.0001 (UTC) FILETIME=[31CE1710:01C817F7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Haley wrote:

> We're listening, really.  It's unacceptable that gcc should break
> code.

In that case a conversion of a conditional branch to an unconditional 
write to a visible variable is not an acceptable behaviour.  Aside from 
the kernel issues, it would break any number of threaded userspace apps.

As was mentioned elsewhere, it's akin to sprinkling

int j = i; i = j;

throughout the code.  If "i" is accessed by multiple threads, this is 
not allowed unless a lock is held.

Chris
