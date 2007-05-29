Return-Path: <linux-kernel-owner+w=401wt.eu-S1751919AbXE2LxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbXE2LxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 07:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbXE2LxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 07:53:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:30479 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbXE2LxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 07:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=X8TI7IqiH3PsA7HuYBns34gt5dI/Q4OPeDuXGqdpuxrzjzmIQEHtGifPh+4sBe8adA2sqnYGOwCr+ZQhR7yl/J/SJTNYBNwD5d87uSUBgTA18ai6d/sRQCNALul7ZRyCP0GtQm3h39CrB5ZX7ciLdeHBE5Ujrr3R9W2xYmZiMPU=
Message-ID: <de6d2b4f0705290453kec2b050pb4d0bebc256b87a5@mail.gmail.com>
Date: Tue, 29 May 2007 12:53:10 +0100
From: "M Macnair" <mmacnair@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Seeding /dev/random not working
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In brief: Adding entropy by writing to /dev/[u]random doesn't appear
to be working.  I am aware that the reported available entropy (via
/proc/sys/kernel/random/entropy_avail) will not increase; the symptom
is /dev/random keeps spitting out the same numbers.

I have two embedded boards (one ARM, one PowerPC), running two
different versions of 2.6.  They have no hard drives, keyboards or
mice.  They each have a NIC, but I understand these make no
contribution to the entropy pool.

Many distros ship with an init script that saves and restores the
entropy pool on startup and shutdown.  The bit that interests me that
is called on startup is (my comments):
	if [ -f $random_seed ]; then
		cat $random_seed >/dev/urandom  # should seed the pool
	fi
	dd if=/dev/urandom of=$random_seed count=1 2>/dev/null # save some
data from urandom for next boot
I have rebooted my boards many times, and after each boot I read the
contents of $random_seed.  Whilst it does not happen every time, the
contents of $random_seed are /often the same/.  To give you a feel:
rebooted 11 times, got a total of 3 different outputs.

This suggests that cat'ing the contents of the random_seed file into
/dev/urandom is not actually increasing the available entropy at all;
indeed it is having no effect whatsoever.

This is obviously a serious issue on these boards, as writing to
/dev/random is the only source of entropy.

In place of these startup scripts I have tried my own script that
explicitly cats in a load of data, and then reads out several K from
/dev/urandom - the data that is read out is normally the same, no
matter what data is written.

I put the fact that this is not 100% reproducible down to timing
variations, which is also the reason why all the experimentation has
been done at startup - the reading and writing occurs at very nearly
exactly the same kernel time, every time it boots.

Is this a bug?  Am I doing something stupid?

Thanks,
Michael Macnair
