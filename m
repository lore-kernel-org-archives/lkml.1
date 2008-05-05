Return-Path: <linux-kernel-owner+w=401wt.eu-S1760009AbYEEP1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009AbYEEP1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 11:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756735AbYEEP1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 11:27:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:22606 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465AbYEEP1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 11:27:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ucsWpkNvpY3CHg5nAy+UbDk5pZKbh+1SjYlZoJTmmkFe84Uce2fsFOAShXoeNMtIMbgU6WdaCxC94PrJmKLsPfCas5loHikdLM86GYjrvUCJpo8+pAGzAHiCRW/MSlW0Dox1pXWpT8O1GbYw662TSr3VOpJBTTi2dtIMOAN2Miw=
Message-ID: <517f3f820805050827w4e880f94pfb19593f21d331b9@mail.gmail.com>
Date: Mon, 5 May 2008 17:27:18 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: MAP_POPULATE behavior change?
Cc: "Michael Kerrisk" <mtk.manpages@googlemail.com>,
       lkml <linux-kernel@vger.kernel.org>, mk <michael.kerrisk@gmail.com>
In-Reply-To: <20080505125450.GB10312@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4815BDF5.9070506@gmail.com> <20080505122316.GE5018@wotan.suse.de>
	 <cfd18e0f0805050542w20bee7f5v8b6125c8b399e63b@mail.gmail.com>
	 <20080505125450.GB10312@wotan.suse.de>
X-Google-Sender-Auth: 642105f47be5e3cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

>  > > > Also, can you summarize the status of MAP_NONBLOCK?  Is it now
>  > > > a no-op?
>  > >
>  > > Yes, it is.
>  >
>  > Hmm -- going back and re-reading the code, there is:
>  >
>  >         if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
>  >                 make_pages_present(addr, addr + len);
>  >
>  > That means that MAP_NONBLOCK makes *MAP_POPULATE* a no-op.
> Was that intended?
>
>
> Ah, my logic wasn't up to scratch there. Yes of course MAP_NONBLOCK is not
>  a noop, but it makes MAP_POPULATE into a noop. So it still guarantees
>  that the call will not block and that the kernel will make some kind of
>  best effort to populate the mapping... for some values of "some kind of"
>  (ie. "nothing" ;)).
>
>  It's done this way of course so it is still safe to call MAP_NONBLOCK if you
>  don't want to block, and thus everything stays backwards and forward
>  compatible.

Thanks.

Continuing on from there, what is the status of the flags argument for
remap_file_pages() now.  the man page curently carries this text:

    The flags argument has the same meaning as for mmap(2),
    but all flags other than MAP_NONBLOCK are ignored.

My question is: is it still true that flags other than MAP_NONBLOCK
are ignored?  A quick glance at the code leads me to suspect not.
(I'm not sure if you made the recent changes to that code or not?)

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
