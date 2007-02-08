Return-Path: <linux-kernel-owner+w=401wt.eu-S1423296AbXBHUGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423296AbXBHUGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 15:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423304AbXBHUGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 15:06:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423296AbXBHUGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 15:06:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix cc-option-yn whitespace
In-Reply-To: Linus Torvalds's message of  Wednesday, 7 February 2007 20:34:20 -0800 <Pine.LNX.4.64.0702072024330.8424@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
X-Windows: you'll envy the dead.
Message-Id: <20070208200636.3222518005D@magilla.sf.frob.com>
Date: Thu,  8 Feb 2007 12:06:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes.. It doesn't seem to happen with make-3.81, for some reason, and I 
> don't see why the leading space happens. Maybe somebody with deep GNU make 
> knowledge knows.

You probably think that's me, but thankfully I have succeeded in forgetting
more about GNU make than anyone else knew.  I wouldn't be much surprised if
3.81 changed some details about whitespace in `call', or in `define', or
something else like that; people keep diddling with make.  At least in the
world I knew, only whitespace after an = or := is stripped like you might
have been expecting, and not whitespace after commas (I mean, why else
would make have the `strip' function?).  All of the $(call foo, a, b) uses
introduce whitespace (vs $(call foo,a,b)).  It's been luck, or silent
careful tweaking, that's made all those work out right so far.  Note also
that the new form of cc-option-yn results in:
      then echo " "y""; \
      else echo " "n""; \
in those commands.  Some other uses of the functions turned into
checker-shell uses might have doubled quotes (i.e. unquoted text) now too.
(People always think make is sh, but it's m4.)

I have long ago sworn off thinking too hard about other people's makefiles
that get arcane with GNU make features.  (You don't feel compelled to watch
every piece of porn on the net that people use Linux to get there, do you?)
So I just did the minimal tweak to fix the concrete regression, though I'd
have to say that the "cleanup" has made things messier and more obfuscated.


Thanks,
Roland
