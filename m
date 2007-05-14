Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbXENPYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbXENPYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 11:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbXENPYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 11:24:32 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:25380 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbXENPYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 11:24:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VMi06xrpBbJf6a9b/c8o7wMPBnBFJ66xHsWRg4J8pbk+DHb5IMidTU9YD/0/uiBALCAEF526sdGG+YsBfzGq07LhOgFN8jE0bFEyBNDbsmdFeTNCdFrYfOT/4WOf1ggMV37tRrWUbZuKsJF/upbNtMlUCo+1k+AVfekeTVhWr2I=
Message-ID: <7ac1e90c0705140824i54e1c43ela3ab3d89827c0339@mail.gmail.com>
Date: Mon, 14 May 2007 16:24:29 +0100
From: "Bahadir Balban" <bahadir.balban@gmail.com>
To: "Learning Linux" <learninglinux4@gmail.com>
Subject: Re: Why can't we sleep in an ISR?
Cc: "pradeep singh" <2500.pradeep@gmail.com>, kernelnewbies@nl.linux.org,
       linux-newbie@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <9f1dc2cf0705140016w6d8f44f9wec7586e7879af873@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9f1dc2cf0705132337k13aa3ccesc575d4550492a24e@mail.gmail.com>
	 <366312910705140010m78b215a2t1753445e81120288@mail.gmail.com>
	 <9f1dc2cf0705140016w6d8f44f9wec7586e7879af873@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/07, Learning Linux <learninglinux4@gmail.com> wrote:
> Ok, but how about an ISR, that does not take any locks? Why can't we
> sleep in SUCH an ISR?
> LL
> -

The killer reason why you can't sleep in an interrupt is because an
interrupt is not associated with any context in the first place. What
is a context, then? It is the state information for a process. This
includes the kernel and userspace stack pointers, the register set,
and the page tables for that process. The scheduler has access to all
this information, to preempt one process and run another. Contrary to
this, an interrupt, depending on the version of your kernel and arch,
uses a separate irq stack or the kernel stack of the interrupted
process. An irq is not a context but merely a temporary execution to
be concluded asap.

Hope this helps,
Bahadir
