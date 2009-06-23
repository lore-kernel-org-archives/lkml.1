Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbZFWT10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbZFWT10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbZFWT1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:27:16 -0400
Received: from lazybastard.de ([212.112.238.170]:47676 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbZFWT1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:27:15 -0400
Date: Tue, 23 Jun 2009 21:26:49 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Marco <marco.stornelli@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Bird <tim.bird@am.sony.com>,
       Chris Simmonds <chris@2net.co.uk>, Arnd Bergmann <arnd@arndb.de>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] Pramfs: Include files
Message-ID: <20090623192648.GB23119@logfs.org>
References: <4A33A7EC.6070008@gmail.com> <200906221317.04166.arnd@arndb.de> <4A3FC7F1.5050108@gmail.com> <200906222033.20883.arnd@arndb.de> <4A3FDBFE.8050509@2net.co.uk> <20090622203034.GA12587@uranus.ravnborg.org> <4A3FFF17.9020701@am.sony.com> <20090623042106.GA17159@uranus.ravnborg.org> <4A411319.4020108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A411319.4020108@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 June 2009 19:38:33 +0200, Marco wrote:
> 
> dd? You haven't got any device file to have a dump. I think we're going
> a bit out of scope. I had some doubt to support rootfs in pram and after
> some feedback and the comments of this review I think I'll remove it
> from the next release (to understand some aspects of this fs with the
> kernel community was my main goal for this review). I agree to use the
> native endian. As I said the important thing is that if an user want to
> use it in a 64bit environment then the fs must work well and then it
> must be designed to support even this situation, I think it's obvious.

Glancing at the discussion with Pawel, I see two paths to follow.  One
is to turn pramfs into a full-features all-round general-purpose
filesystem with mkfs, fsck, xattr and any number of additional features.
That way lies doom, as you would compete against ext2+xip and have
little new to offer.

The other path is to make/keep pramfs as simple as possible for
comparatively specialized purposes, like flight recorder data and dump
information.  Main selling point here is the amount of vulnerable code
in the total package.  ext2 + block layer + vfs helpers is relatively
large and many things may go wrong in a panic situation.

So I agree with you that many things expected from general purpose
filesystems simply don't apply to pramfs.  Moving mkfs into the kernel
is a fair tradeoff, when the required code is small.  Endianness is a
different case imo.  dd may not work, but a jtag probe will happily get
you the dump to your development machine.

And even within the same box you can have more than one architecture and
endianness.  http://www.top500.org/system/9707 will show you one such
beast, which happens to have the top bragging rights at the moment.  I
don't want to endorse such strange beasts, but there is no good reason
not to support reading the ppc-written fs from the opteron.  In fact,
there is no reason full stop.

Jörn

-- 
Beware of bugs in the above code; I have only proved it correct, but
not tried it.
-- Donald Knuth
