Return-Path: <linux-kernel-owner+w=401wt.eu-S1752207AbXAZWFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbXAZWFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 17:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbXAZWFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 17:05:36 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:55911 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbXAZWFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 17:05:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fup/hdsAjwmqxuY0NNnKuvWREY3KB38p5vw0ZeGOLmuH4iNECkNsZj4vFw2zmQP3xYePN2OW5ZTn3l3pVXO/uRWOSAQgDj4NTPIM6GX6je4P6acUA9i7yGPVTqVqXYNsR3A2zxfdlBoXnL9QHh4IXOQ2F+Ns+Pk2ldaQZtvTP8k=
Message-ID: <f2b55d220701261405v3b432306q6a955258598f8b32@mail.gmail.com>
Date: Fri, 26 Jan 2007 14:05:31 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Segher Boessenkool" <segher@kernel.crashing.org>
Subject: Re: kernel + gcc 4.1 = several problems
Cc: "Denis Vlasenko" <vda.linux@googlemail.com>, akpm@osdl.org,
       "Albert Cahalan" <acahalan@gmail.com>, linux-kernel@vger.kernel.org,
       s0348365@sms.ed.ac.uk, "Linus Torvalds" <torvalds@osdl.org>,
       bunk@stusta.de, mikpe@it.uu.se
In-Reply-To: <11fc5e81b224467e25caaefb66ba82e7@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920701032311l2c37c248s3a97daf111fe88f3@mail.gmail.com>
	 <787b0d920701040904i553e521fsb290acf5059f0b62@mail.gmail.com>
	 <Pine.LNX.4.64.0701040921010.3661@woody.osdl.org>
	 <200701070525.45974.vda.linux@googlemail.com>
	 <11fc5e81b224467e25caaefb66ba82e7@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ALSA + GCC 4.1.1 + -Os is known to be a bad combination on some
arches; see http://gcc.gnu.org/bugzilla/show_bug.cgi?id=27363 .  (I
tripped over it on an ARM target, but my limited understanding of GCC
internals does not allow me to conclude that it is ARM-specific.)  A
patch claiming to fix the bug was integrated into the 4.1 branch, but
my tests with a recent (20070115) gcc-4.1 snapshot indicate that it
has regressed again.

You might also check /proc/cpu/alignment; we have seen the alignment
fixup code trigger for alignment errors in both kernel and userspace.
The default appears to be to IGNORE alignment traps from userspace,
which results in bogus data and potentially a wacky series of system
calls, which could conceivably trigger an oops.  I am told that echo 2
> /proc/cpu/alignment activates the kernel alignment fixup code, and
that 3 turns on some sort of logging in addition to the fixup (haven't
pursued this myself).  No idea whether this is relevant to your CPU.

Cheers,
- Michael
