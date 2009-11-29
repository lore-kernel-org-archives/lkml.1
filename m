Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbZK2R22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbZK2R22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 12:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbZK2R21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 12:28:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:51787 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbZK2R2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 12:28:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wE+aCo+V6m9NXCahZ9flJV6+UxM1tx/3laENz4vbncIYp7BFBXT+18oOX3+ktcWPxH
         DukWWiHPK5Uw/BhHEHgsnz1vyZvmFmW1B5tgO7h7YeELHa/b6qgjXw6PfN4d5YKCVf3i
         jZqUkIsgEtHCYWh7F6pfalFmCAi6DXBwj9KMM=
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andy Walls <awalls@radix.net>, Jon Smirl <jonsmirl@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       Christoph Bartelmus <lirc@bartelmus.de>, dmitry.torokhov@gmail.com,
       j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, mchehab@redhat.com,
       stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
In-Reply-To: <20091129124011.4d8a6080@lxorguk.ukuu.org.uk>
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>
	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	 <m3aay6y2m1.fsf@intrepid.localdomain>
	 <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
	 <1259469121.3125.28.camel@palomino.walls.org>
	 <20091129124011.4d8a6080@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 Nov 2009 19:28:23 +0200
Message-ID: <1259515703.3284.11.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-29 at 12:40 +0000, Alan Cox wrote: 
> > BTW, circa 1995 my serial mouse "Just Worked" in Linux.  Sometime around
> 
> Correct X11 just talked to the serial ports. In fact that is still the
> way to configure it if you want any sanity in life.
> 
> > and serial connected IRs.  It's also too convenient to access USB IR
> > hardware from existing userspace drivers to bother porting into the
> > kernel.
> 
> Userspace needs a way to identify IR hardware and to interface with it
> using the right protocol. It's not clear the kernel needs to provide
> anything more than minimal hardware interfaces in most case - be that
> serial, libusb, ...

Exactly.
As it currently stands, kernel provides lircd the pulse/space timing,
lirc parses that, and sends input events via uinput.
lircd behaves just like an userspace driver, and the biggest advantage
is that it can access its configuration directly, unlike kernel solution
that will have to use some configfs hack.


It can use its own older interface, but that is now optional.
Also its not that hard to make lirc scan is database and adapt to the
remote that is used.
This should give the user absolutely zero configuration.

Instead, there is strong push to put lircd, the userspace daemon's
functionality  into kernel.
This has zero advantages besides good developer feeling that "My system
has one less daemon..."

Best regards,
Maxim Levitsky

