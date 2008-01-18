Return-Path: <linux-kernel-owner+w=401wt.eu-S1762949AbYARPjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762949AbYARPjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762743AbYARPjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:39:17 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:59438 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762724AbYARPjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:39:15 -0500
Message-ID: <4790C80B.4090505@nortel.com>
Date: Fri, 18 Jan 2008 09:38:51 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: davids@webmaster.com
CC: torvalds@linux-foundation.org, Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clameter@sgi.com, penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
References: <MDEHLPKNGKAHNMBLJOLKKEKDJJAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEKDJJAC.davids@webmaster.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jan 2008 15:38:55.0800 (UTC) FILETIME=[3C3D6380:01C859E8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:

> 2) The 'kfree' operation changes the logical state of the object pointed to,
> as the object goes from existent to non-existent.

I don't think that kfree() itself changes the state of the object.  It 
doesn't call a destructor or anything like that, so the object itself 
must be "inert" before the call to kfree().  That is, at the time of the 
kfree() call the system must have ensured that the object will no longer 
be used by anything.

The call to kfree() is simply bookkeeping--allowing that memory to be 
reused by other parts of the kernel.

> 3) It is most useful for 'kfree' to be non-const because destroying an
> object through a const pointer can easily be done in error. One of the
> reasons you provide a const pointer is because you need the function you
> pass the pointer to not to modify the object. Since this is an unusual
> operation that could be an error, it is logical to force the person doing it
> to clearly indicate that he knows the pointer is const and that he knows it
> is right anyway.

I have a certain amount of sympathy for this view...it's a fairly 
painless way to reduce the likelihood of errors.  At the same time, I 
don't think I've ever run into this problem myself--is it really all 
that common?

Chris
