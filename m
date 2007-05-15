Return-Path: <linux-kernel-owner+w=401wt.eu-S1761322AbXEOH2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761322AbXEOH2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbXEOH2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:28:08 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:30367 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030AbXEOH2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:28:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OWV3RL1h3ChxIULo0hXu57W6HMvm37hvH3Ay3KhVF2dQf91CtvOSYWAsCIDSdySWTnoh92pdLGPh6mYDzxgLIOOuZzQIoA9AHUTDqX926/ljN2YPgrbyVqo3HHGLoIW+j90H/hwKltzWWKNvbqW7upJL/bi9IJnSX1WjEFNmWCw=
Message-ID: <a2ebde260705150028j16cc12a2ya6d5906c97ce193b@mail.gmail.com>
Date: Tue, 15 May 2007 15:28:06 +0800
From: "Dong Feng" <middle.fengdong@gmail.com>
To: "pradeep singh" <2500.pradeep@gmail.com>
Subject: Re: Why can't we sleep in an ISR?
Cc: "Bahadir Balban" <bahadir.balban@gmail.com>,
       "Learning Linux" <learninglinux4@gmail.com>, kernelnewbies@nl.linux.org,
       linux-newbie@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <366312910705150010p623f9732mc498f457245d23a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9f1dc2cf0705132337k13aa3ccesc575d4550492a24e@mail.gmail.com>
	 <366312910705140010m78b215a2t1753445e81120288@mail.gmail.com>
	 <9f1dc2cf0705140016w6d8f44f9wec7586e7879af873@mail.gmail.com>
	 <7ac1e90c0705140824i54e1c43ela3ab3d89827c0339@mail.gmail.com>
	 <366312910705142217geba69dbm98a6c0bf2aabb937@mail.gmail.com>
	 <a2ebde260705142345m440c70fbu33934334fbb69f8e@mail.gmail.com>
	 <366312910705150010p623f9732mc498f457245d23a1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > I don't think so but I am not sure.
>
> Aliter, i think so.How can an interrupt's execution time go
> unaccounted then?
> I guess it does not, only the current processes running
> time is accounted for.
> Thoughts?
>

The interrupt handler's execution time will definitely defer the
execution of the process, but I think it does not steal the process's
time slice (the time_slice field not subtracted).

> > > Doesn't it run in current process's context ?
> > >
> >
> > No. I think the concept of process context is a higher-level logical
> > concept. Though the interrupt share stack with the interrupted
> > process, in my opinion it logically does not share the context with
> > the process.
>
> Yes, you are right as i can infer. thats why ISRs
> are special kernel control paths.
> But the poster asked, why can't we make ISRs to
> share context with the interrupted process
> if
> it not holding any locks? This is rather a desing issues
> IMO rather than imlementation, isnt it?
>
> I guess even if it is possible, it would over complicate the handler code.
> Better trying to keep it simple i guess. Please CMIIW

My understanding is, the ISR is in different context from the process
because of the definition of term *context*. In my opinion, to say two
code pieces running in the same context means that two pieces of code
has some logical relationship to meet a common objective. That's why I
said *context* is a higher-level logical concept. It's not a concept
defined in the level of hardware or code implementation, but instead
in the level of logical. I think, by its definition, it makes no sense
to say an ISR share context with the process interrupted by it because
an ISR just randomly interrupts a process, with no logical
relationship.
