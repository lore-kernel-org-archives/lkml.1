Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002Ab0AEAOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab0AEAOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563Ab0AEAOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:14:15 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:47076 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab0AEAOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:14:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tFezUL5c7zDukDISBoJnDX4NCP+MzQtqoNBG3zGaZmCmqVwBy0QDaB6xYbwUBfcQcI
         swCqVp9Ffo2ltibmb0yvuYw/IvTVZVMdSZIIUd66indYF8E6oAbdDKlnfkD9LQNcNt9L
         TEVsOUSLHKCeB56S96ntcQorUDuMyuXLpiyYY=
MIME-Version: 1.0
In-Reply-To: <20100104224817.GA21695@elf.ucw.cz>
References: <200912142122.nBELMW7d001243@mustang.cs.nmsu.edu>
	 <20091216103423.GE1377@ucw.cz>
	 <alpine.LNX.2.00.0912161504360.3755@pobox.suse.cz>
	 <7f9100aac5f9b06ec78efff25c7a5a71.squirrel@intranet.cs.nmsu.edu>
	 <20100104224817.GA21695@elf.ucw.cz>
Date: Tue, 5 Jan 2010 08:14:12 +0800
Message-ID: <45a44e481001041614i35ceef84q5f12a068e2f0b97b@mail.gmail.com>
Subject: Re: [PATCH] Logitech G13 driver (fixed cc list --- ignore others)
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>,
       Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       krzysztof.h1@wp.pl, Andrew Morton <akpm@linux-foundation.org>,
       linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
       linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 5, 2010 at 6:48 AM, Pavel Machek <pavel@ucw.cz> wrote:
>
> Ok, but I guess you should cc auxdisplay people in future.

Hi Pavel,

I just looked at the drivers/auxdisplay directory and got a bit
confused. The reason I got confused is because auxdisplay is actually
an fbdev driver but it is outside of the drivers/video directory. It
looks like there has only been 1 commit and that was for the Samsung
KS0108 controller. It also sort of uses platform support but the way
it is abstracted is odd to my thinking. The controller is ks0108, so
in my mind that would be the code that would be platform independent,
and then that would use a board specific IO driver to push data (eg:
parport or gpio or usb). I think in the long term it would probably
make sense to write a cleaner approach with a drivers/video/ks0108.c
which is cleanly platform independent (and back within fbdev proper)
and then a board specific driver in the appropriate location that
handles the IO.

Thanks,
jaya
