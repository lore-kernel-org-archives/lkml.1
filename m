Return-Path: <linux-kernel-owner+w=401wt.eu-S933230AbXK2TL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230AbXK2TL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759614AbXK2TLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:11:46 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:4899 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001AbXK2TLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:11:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RH9YQWAWLlLB7NNYDmqmQyYD/E1RoI0CEHfO3fHN/yW834fCAtHaPHsY5Mf8nDgw7uznWxlDY5PUJ2IYPjy9N4mtVGBTaAEEq5Hoir5hqi3t0fAGfPXa1Ny+rrdmIVRj3nYzMMXUWDYnWSsVPw2AL4hv/E2zfvzaSFzUXtxGroU=
Message-ID: <2c0942db0711291111t16a4eb49h6b1e83ddf7bb4cf9@mail.gmail.com>
Date: Thu, 29 Nov 2007 11:11:29 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Jon Masters" <jonathan@jonmasters.org>
Subject: Re: Out of tree module using LSM
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, tvrtko.ursulin@sophos.com,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Casey Schaufler" <casey@schaufler-ca.com>,
       "Christoph Hellwig" <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
In-Reply-To: <1196362612.6473.98.camel@perihelion>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071128183040.GW8181@ftp.linux.org.uk>
	 <OF699E23DA.E36E712D-ON802573A2.00591FA8-802573A2.005A44A2@sophos.com>
	 <20071129173601.34273083@the-village.bc.nu>
	 <2c0942db0711291040j4ce48acagb753b64c4b8c1357@mail.gmail.com>
	 <1196362612.6473.98.camel@perihelion>
X-Google-Sender-Auth: 5d564c2ac7be63e3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2007 10:56 AM, Jon Masters <jonathan@jonmasters.org> wrote:
> On Thu, 2007-11-29 at 10:40 -0800, Ray Lee wrote:
> > On Nov 29, 2007 9:36 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > > closed. But more importantly further access to it can be blocked until
> > > > appropriate actions are taken which also applies with your example, no? Is
> > >
> > > That bit is hard- very hard.
> >
> > In some sense it seems like the same problem faced by dynamic
> > translators such as Qemu. They really want to vet a dirtied or faulted
> > page before allowing the app to run unhindered. It's be nice to have
> > some way to do that without virtualizing the whole of userspace.
>
> Like I hinted at, you can't just "vet a page". Because a page alone is
> meaningless garbage, unless it happens to be an extremely small program,
> with headers, all nicely aligned. Most likely you don't know if a random
> page of data is code from a COFF file, ELF file, or some random crap I
> typed in at a terminal after having too much coffee.
>
> So. You'd need to scan *all the pages* of *the entire file*, every time
> that you performed any type of operation.

*blink* Really? To lift Alan's example, a naive first implementation
would be to create a suffix tree of all of ESR's works, then scan each
page on fault to see if there are any partial matches in the tree. If
there's a partial match that ends at the page boundary, mark the page
as questionable, but let execution/reading continue. On the next
linear page, if the match finishes, mark that one as bad, and disallow
access. That wouldn't be very expensive (in terms of scanning effort).

But I'm by no means an anti-malware guy, so perhaps I'm spouting crap,
especially given that I've thought about this a total of five minutes.

Regardless, thanks for doing the coordination work with them, and for
interfacing them with the kernel community. I'm really going to shut
up now.
