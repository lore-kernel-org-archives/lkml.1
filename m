Return-Path: <linux-kernel-owner+w=401wt.eu-S935247AbYEBQpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935247AbYEBQpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 12:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934104AbYEBQpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 12:45:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:8133 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934031AbYEBQpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 12:45:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=epCyEoHVCuVZcFZuk8Qw1XaSKgQZN2XX0mYAOkd5wzVTNVbWnPc9YId/6cyM7juShyas7EiujmoinMrhxkdKCh0UfQrXsG4mempg4YpBQZnO738uPqNUG3IGrqmvJ2A/sfQgsaKIkaSdMoGOS9WuvL/ox8sbPx0fzymUxp/Pn64=
Message-ID: <2c0942db0805020945i2f46a41dl28cdcec25c9e2ac3@mail.gmail.com>
Date: Fri, 2 May 2008 09:45:04 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Jesper Krogh" <jesper@krogh.cc>
Subject: Re: Many open/close on same files yeilds "No such file or directory".
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <481B395E.5070505@krogh.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4819E316.7000607@krogh.cc>
	 <20080501223938.921f7cd2.akpm@linux-foundation.org>
	 <481ACEC4.2040205@krogh.cc> <481B3115.30705@krogh.cc>
	 <2c0942db0805020847q2fdc0480m3eb892bf2bd0b3a@mail.gmail.com>
	 <481B395E.5070505@krogh.cc>
X-Google-Sender-Auth: f9fe26a3f464eea3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2008 at 8:55 AM, Jesper Krogh <jesper@krogh.cc> wrote:
>
> Ray Lee wrote:
>
> > On Fri, May 2, 2008 at 8:19 AM, Jesper Krogh <jesper@krogh.cc> wrote:
> >
> > > Jesper Krogh wrote:
> > >
> > >
> > > >
> > > > > I'd suspect that after 1e8 loops your CPU got too hot and started to
> > > > > misbehave.
> > > > >
> > > > >
> > > > Hardware is an Sun Fire X4600 (8xdual-core AMD64 processors). The
> > > > problem seem to be tied to this filesystem. (I cannot havent been able
> > > > to reproduce it on the /-mounted disk of the same system. So if a cpu
> > > > problem.. then it shouldn't be tied to a specific filesystem?
> > > >
> > > > This is the only activity on the system .. so a load of 1 / 16cpus.
> > > >
> > > >
> > >  I've tried to explore this suggestion (the best I could).
> > >
> > >  There are 2 ext3 filesystems locally mounted. / and this one. Running
> 16
> > > parallel runs of this program on a file on the /-mounted filesystem
> cannot
> > > reproduce the problem. If it was linked to hot hardware, I believe I
> should
> > > be able to reproduce it this way. The servers are in a 17 degress
> > > serverroom.
> > >
> > >  It changes alot when.. it actually happens. The "earliest ones" has
> been
> > > from 200000 cycles.
> > >
> >
> > Run 16 in parallel on /, and another 16 simultaneously on the trouble
> > filesystem? If you continue to get errors only on the 'trouble'
> > filesystem, and no errors start occurring on / coincident, then it
> > sounds pretty localized.
> >
>
>  That test has been done. I can only reproduce it on this filesystem. But I
> cannot really conclude that it is only present there.. since sometimes my
> testprogram just goes on .. and dies past 1 billion cycles. But I have never
> gotten errors from the / filesystem on the same installation.

Sorry for belaboring the point, but reading up-thread I see you ran
both / and /troublefs one after the other, but you're saying you also
ran them at the same time? If so, that would seem to conclusively rule
out hardware overheating.
