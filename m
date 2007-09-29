Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbXI2TsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbXI2TsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 15:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbXI2TsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 15:48:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:41863 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbXI2TsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 15:48:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q3uOgQz5Gz7zsL8ny0NOd4nJZi7tVRZSnhjeGlJ0DjaSWCBfHjV7F3XsVDQPvn6gsJDuiXUNK1hI0lLpmH03zqXSv7omZqKssS+0nuUD8J0RNr7V+nLP+fi0vcMxZBgWjcd32Au8Ny5Y+Uh+qEuAhnUPmF1CSXTcuHNuYRO0Cak=
Message-ID: <863e9df20709291248y6d4b3881j527dd3adbb9f3340@mail.gmail.com>
Date: Sun, 30 Sep 2007 01:18:09 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "=?ISO-8859-1?Q?Daniel_Sp=E5ng?=" <daniel.spang@gmail.com>
Subject: Re: Out of memory management in embedded systems
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <cfd9edbf0709281358k3f6307e8h4d2c131378645747@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <cfd9edbf0709280555n51afa8aft5040331ae9c227fd@mail.gmail.com>
	 <Pine.LNX.4.61.0709280857520.8940@chaos.analogic.com>
	 <cfd9edbf0709280630x7396e49fi523e1d58aab9458a@mail.gmail.com>
	 <Pine.LNX.4.61.0709281000300.9062@chaos.analogic.com>
	 <cfd9edbf0709280714u7a03ec16pfe3cb7328dbab7ad@mail.gmail.com>
	 <Pine.LNX.4.61.0709281105340.9420@chaos.analogic.com>
	 <cfd9edbf0709281358k3f6307e8h4d2c131378645747@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/29/07, Daniel Spång <daniel.spang@gmail.com> wrote:
> > An embedded system is NOT an ordinary system that happens to
> > boot from flash. An embedded system requires intelligent design.
>
> We might be talking about slightly different systems. I agree that
> systems that are really embedded, in the classic meaning often with
> real time constraints, should be designed as you suggests. But there
> are a lot of other systems that almost actually are ordinary systems
> but with limited memory and often without demand paging.

[snip]

> For those systems I think we need a method to dynamically decrease the
> working set of a process when memory is scarce, and not just accept
> that we "are screwed" and let the OOM killer solve the problem.

In certain cases, I guess it could be a problem in the embedded
environment. Especially while running general purpose applications
with carefully designed real-time tasks. An OOM in such a case is
unacceptable.

The whole problem looks like an extension of page frame reclamation in
user space. If the user application's cache was owned by the kernel
(something like vmsplice with SPLICE_F_GIFT?), and the application
managed it accordingly, then they could probably be brought under the
purview of kernel's memory reclamation. This would mean that
applications wouldn't need to be triggered on low memory, and leave
memory freeing to the kernel (simpler and uniform). Perhaps it is even
possible to do this in the kernel currently somehow...?

--
Abhishek Sagar

-
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
