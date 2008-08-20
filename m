Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbYHTVYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbYHTVYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYHTVYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:24:05 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:4697 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbYHTVYC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:24:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=hHmOnQVM0B+5fSon36tIqzYGaMgKmXkVj4HoaRtikfMBhX6Uq1seGRNwVXsO1smNnT
         api8dmL3KW2ipPox5Ioq0JIuvSzJJrSH4kDHyNuPSP6xRIK/VyhJnScBHo5gwA84SidT
         aY4mfqIRtpJjbN2QFW3QczAeb4c/uBs4+7ueU=
Date: Wed, 20 Aug 2008 23:23:41 +0200
From: Diego Calleja <diegocalleja@gmail.com>
To: Bart Trojanowski <bart@jukie.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: vfat BKL/lock_super regression in v2.6.26-rc3-g8f59342
Message-ID: <20080820232341.2a845cb3@diego-desktop>
In-Reply-To: <20080820022712.GF28029@jukie.net>
References: <20080819220311.GA28029@jukie.net>
	<alpine.LFD.1.10.0808191505590.3324@nehalem.linux-foundation.org>
	<20080820001845.GC28029@jukie.net>
	<alpine.LFD.1.10.0808191729330.3324@nehalem.linux-foundation.org>
	<alpine.LFD.1.10.0808191748040.3324@nehalem.linux-foundation.org>
	<20080820022712.GF28029@jukie.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 19 Aug 2008 22:27:12 -0400, Bart Trojanowski <bart@jukie.net> escribió:

> I was reading the vfat code, and it turns out that vfat has a "flush"
> mount option.  Which is documented in the code (not in the manpage) as:

Yeah, probably the one place where it was documented was 
http://kernelnewbies.org/Linux_2_6_19 (commit ae78bf9c4f5fde3c67e2829505f195d7347ce3e4).

Apparently at least one person must have read it, because there's a lot
of dmesgs in the interweb with this string in it:

"FAT: Unrecognized mount option "flush" or missing value"

due to HAL trying to mount vfat filesystems with that option in kernels
that don't support it. Which broke USB stick support for them, BTW, and
generated a lot of posts in forums asking for help.

IOW: not only this option exist, it's also being used by default in all
the vfat mounts on the linux systems that use HAL, ie. almost all of them.

