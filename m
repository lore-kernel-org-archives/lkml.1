Return-Path: <linux-kernel-owner+w=401wt.eu-S1757798AbXE2Ni5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbXE2Ni5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbXE2Nis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:38:48 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:9867 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbXE2Niq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:38:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mTd0Xe1zoInhB4IalGLBLKjQt2uuktEWHOyCsbTRMh6OTE4MnxNoFXYebxq+6a4ZAbMc2KkAXV7oP9Jrg91CAgJ5vNrVjMDLF01yfaDblmroqxM2IRZqudtGARWVqoHYnui9DQR3xBRKKQ3jCGEJrktJZMVUiuvqE8UtynB9lNM=
Message-ID: <de6d2b4f0705290638w3e862274jd49b18135790cea5@mail.gmail.com>
Date: Tue, 29 May 2007 14:38:45 +0100
From: "M Macnair" <mmacnair@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, "M Macnair" <mmacnair@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Seeding /dev/random not working
In-Reply-To: <20070529131501.GA9899@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <de6d2b4f0705290453kec2b050pb4d0bebc256b87a5@mail.gmail.com>
	 <20070529131501.GA9899@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/07, Theodore Tso <tytso@mit.edu> wrote:
> On Tue, May 29, 2007 at 12:53:10PM +0100, M Macnair wrote:
> Ok, so this is telling me a couple of things.  First of all, if you're
> only getting three outputs, it means that you don't have any
> peripherals feeding entropy into the system from the boot sequence.
> Without any hard drives, keyboards or mice, and a NIC whose device
> driver hasn't been configured to feed entropy, you're definitely
> hosed.

Yes.  However this isn't the issue I'm concerned with at the moment.

> Secondly, and more importantly, your boot scripts aren't set up
> correctly.

Sorry, I only posted the startup bit - the same does indeed happen on
shutdown, however I wasn't interested in it for the purposes of the
tests.

The key point I was trying to put across was that I can't get the
seeding process to work.  No matter what I wrote to /dev/urandom on
startup, the output from reading /dev/urandom immediately afterwards
was the same (ignoring the occasional variation that I put down to
timing).  As I understand it (from man 4 random and the boot script
examples), writing to /dev/[u]random should increase the amount of
entropy, thereby altering the output from the PRNG.

> Another thing which I noticed is that when Matt Mackall took over
> maintainership of /dev/random, he apparently took out one of the
> safeguards I had, which was that before, when entropy was extracted
> from the pool the time stamp when it was extracted was mixed back into
> the pool.  The theory was that an external attacker might not know
> when a program might be calling /dev/random, so mixing in the time of
> that entropy was extracted wouldn't hurt, and might help.  I'll submit
> a patch to add that support back in, which will help you a little.

When did Matt take over?  From my experiments it would appear as
though the time is having an effect on the output, though as I say I'm
not totally sure.

Regards,
Michael Macnair
