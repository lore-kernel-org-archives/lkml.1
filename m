Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbXJURev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbXJURev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 13:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbXJURen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 13:34:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:58921 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbXJURen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 13:34:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Md8/Ezm/EWeyHVBfhizb6dC3DMa+W2rIkFhiF+wXdfKr0wMoTK2LMgSGzFvzT/4gKc1S6o/8lMUFI0fpab4DpkMTHIN/08FLR2WMnFN9IUkzuJd2vzEU/bKZiB7HhZHvuUNKqv2ksTvzLsOYbSl4RNUsK7lUQY80zy4Ln7W5ZAY=
Message-ID: <b647ffbd0710211034s664eec81hb3dac639f5575fac@mail.gmail.com>
Date: Sun, 21 Oct 2007 19:34:42 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [2.6.23] tasks stuck in running state?
Cc: "Ingo Molnar" <mingo@elte.hu>, "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <b647ffbd0710211025k1e5935a2ra6886724872437c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47192425.6020507@garzik.org> <47192763.9050004@redhat.com>
	 <47192999.6010607@garzik.org>
	 <b647ffbd0710211025k1e5935a2ra6886724872437c8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/10/2007, Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> On 20/10/2007, Jeff Garzik <jeff@garzik.org> wrote:
> > Chuck Ebbert wrote:
> > > On 10/19/2007 05:39 PM, Jeff Garzik wrote:
> > >> On my main devel box, vanilla 2.6.23 on x86-64/Fedora-7, I'm seeing a
> > >> certain behavior at least once a day.  I'll start a kernel build (make
> > >> -sj5 on this box), and it will "hang" in the following way:
> > >>
> > >
> > > Can you try to strace the hanging task?
> >
> > Well, to the system it's running, so that doesn't do much of anything...
> >
> > >
> > >  8482 pts/0    S+     0:00                          \_ /bin/sh /garz/repo/misc-2.6/scripts/hdrcheck.sh /garz/repo/misc-2.6/usr/include /garz/repo/misc-2.6/usr/include/linux/kernelcapi.h /garz/repo/misc-2.6/usr/include/linux/.check.kernelcapi.h
> > >  8484 pts/0    R+     3:10                              \_ grep ^[ \t]*#[ \t]*include[ \t]*< /garz/repo/misc-2.6/usr/include/linux/kernelcapi.h
> > >  8486 pts/0    S+     0:00                              \_ cut -f2 -d<
> > >  8487 pts/0    S+     0:00                              \_ cut -f1 -d>
> > >  8488 pts/0    S+     0:00                              \_ egrep ^linux|^asm
> > > [jgarzik@pretzel misc-2.6]$ strace -p8484
> > > Process 8484 attached - interrupt to quit
> > [sits there, chewing up CPU grepping a 47-line header file]
>
> I think, the following information would be helpful :
>
> (1)  # cat /proc/PID/stat ; sleep 5; cat /proc/PID/stat
>
> as we could know :
>
> - whether utime or/and stime keeps increasing ;
>
> - one of the fields is actually 'eip' ... so we could, hopefully, more
> or less precisely localize the area of the code where it's looping.

sure, this 'eip' will be useless in this case.

[ ... ]

-- 
Best regards,
Dmitry Adamushko
