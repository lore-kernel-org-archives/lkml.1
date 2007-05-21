Return-Path: <linux-kernel-owner+w=401wt.eu-S1763271AbXEUQ20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763271AbXEUQ20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbXEUQ2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:28:10 -0400
Received: from smtp-out.google.com ([216.239.45.13]:30067 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432AbXEUQ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:28:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=YU6PwcY+85tJaAaCbBHocg462w9o50civI6Jg6Mzxl87Ym8WEz+CTW/1bl3fe1F7o
	JWcJqBQmQASEv362BXGuA==
Message-ID: <b040c32a0705210927q24e2cd8fm9f4616941fccfdea@mail.gmail.com>
Date: Mon, 21 May 2007 09:27:44 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Cc: "Kay Sievers" <kay.sievers@vrfy.org>, "Ray Lee" <ray-lk@madrabbit.org>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Andrey Borzenkov" <arvidjaar@mail.ru>, "Uwe Bugla" <uwe.bugla@gmx.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <alpine.LFD.0.98.0705210908170.3890@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F42F3.1080300@madrabbit.org>
	 <200705200124.13026.uwe.bugla@gmx.de>
	 <200705200845.43621.arvidjaar@mail.ru>
	 <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com>
	 <20070520062816.GA4095@ftp.linux.org.uk>
	 <2c0942db0705200822j685ec3b2x399a080622b6fc05@mail.gmail.com>
	 <3ae72650705200854x6a2c829fueff3652653fc21da@mail.gmail.com>
	 <2c0942db0705200910t777214efud489f4bc94433bf5@mail.gmail.com>
	 <1179677799.3311.5.camel@lov.localdomain>
	 <alpine.LFD.0.98.0705210908170.3890@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> Yes. Can somebody who actually _uses_ loop send a tested patch, please?
>
> We're not going to break existing user space over something idiotic like
> this. Not acceptable.
>
> The alternative is to just revert all the loop.c patches. Which I'll do
> unless somebody sends me a tested fix - because as a non-loop user myself,
> I don't have much choice. I assume it is
>
>    commit 73285082 "remove artificial software max_loop limit"
>
> that introduced the new behaviour. Ken?

yes and no. in that commit, I automatically create n+1 device when
loop device n is created, allergically was tested to be fine with
casual usage of "losetup" and "mount -o loop".  However, there is a
bug in that commit when loop.c was compiled as a module.  And when Al
fixed it, he also removed that magic "n+1" trick.

Nevertheless, yes, I'm guilty of introducing the new behavior.
