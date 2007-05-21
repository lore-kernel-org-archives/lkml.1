Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbXEUQf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbXEUQf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbXEUQfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:35:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:62728 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369AbXEUQfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:35:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hYd5jMZcIeOdASEjdjWSRYmJS/dozwBJvC+PUHGKA+TeTQ+4nhJWz6RwKnaw0GPoB1pSOsBq4EFWEFL9I+zj5g7MgsPpRSTr2NdzfFQFK2KEpH8kPUrbR8pHf6iQ7geHCSnlsIuvbw2buMKxmW0lKKL0zDljdXxwmBuMsTVZoRA=
Message-ID: <2c0942db0705210935r72cf076ap946c4f215a61ee5f@mail.gmail.com>
Date: Mon, 21 May 2007 09:35:12 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Ken Chen" <kenchen@google.com>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Kay Sievers" <kay.sievers@vrfy.org>, "Al Viro" <viro@ftp.linux.org.uk>,
       "Andrey Borzenkov" <arvidjaar@mail.ru>, "Uwe Bugla" <uwe.bugla@gmx.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <b040c32a0705210927q24e2cd8fm9f4616941fccfdea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F42F3.1080300@madrabbit.org>
	 <200705200845.43621.arvidjaar@mail.ru>
	 <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com>
	 <20070520062816.GA4095@ftp.linux.org.uk>
	 <2c0942db0705200822j685ec3b2x399a080622b6fc05@mail.gmail.com>
	 <3ae72650705200854x6a2c829fueff3652653fc21da@mail.gmail.com>
	 <2c0942db0705200910t777214efud489f4bc94433bf5@mail.gmail.com>
	 <1179677799.3311.5.camel@lov.localdomain>
	 <alpine.LFD.0.98.0705210908170.3890@woody.linux-foundation.org>
	 <b040c32a0705210927q24e2cd8fm9f4616941fccfdea@mail.gmail.com>
X-Google-Sender-Auth: 6ea74278089be224
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Ken Chen <kenchen@google.com> wrote:
> On 5/21/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > I don't have much choice. I assume it is
> >
> >    commit 73285082 "remove artificial software max_loop limit"
> >
> > that introduced the new behaviour. Ken?
>
> yes and no. in that commit, I automatically create n+1 device when
> loop device n is created, allergically was tested to be fine with
> casual usage of "losetup" and "mount -o loop".  However, there is a
> bug in that commit when loop.c was compiled as a module.  And when Al
> fixed it, he also removed that magic "n+1" trick.

As I said before, the reporter *tested* with Al's two patches
reverted, AND IT STILL FAILED. Your commit had to be reverted as well
to fix the problem.

> Nevertheless, yes, I'm guilty of introducing the new behavior.

It's not a behavior, it's a bug. Whether you reintroduce the n+1
inductive trick is immaterial to the problem at hand. loop.c needs to
populate 8 or max_loop devices upon init to maintain current behavior.
