Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbZEDTOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbZEDTOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 15:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbZEDTOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 15:14:10 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:38686 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbZEDTOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 15:14:09 -0400
MIME-Version: 1.0
In-Reply-To: <49FF3A26.3030407@googlemail.com>
References: <20090501061701.GB19234@kroah.com> <ac3eb2510905010624k891f680s7255af8ae185b5d5@mail.gmail.com> 
	<49FC8EE4.6040408@googlemail.com> <9b2b86520905021255t4a4812dcrcbcc32f36acd6039@mail.gmail.com> 
	<ac3eb2510905021447m1fad2382h342b4d4279b75d3d@mail.gmail.com> 
	<20090504162011.GO17956@suse.de> <ac3eb2510905040953t29e104eel1f820516195c623a@mail.gmail.com> 
	<49FF2BD4.3070409@googlemail.com> <ac3eb2510905041113x58bdb807od7dd4a6ce258e317@mail.gmail.com> 
	<49FF3A26.3030407@googlemail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 4 May 2009 21:13:53 +0200
Message-ID: <ac3eb2510905041213m24aec237y1f3b5648df3106e0@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Michael Riepe <michael.riepe@googlemail.com>
Cc: Lars Marowsky-Bree <lmb@suse.de>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 4, 2009 at 20:55, Michael Riepe
<michael.riepe@googlemail.com> wrote:
>> Dynamic device numbers! A static /dev does not work at all for many
>> subsystems, not to mention the risk you take by talking to the wrong
>> device pointed to, by your incorrect static device nodes. It's not an
>> option at all today, and it will get much worse in the future.
>
> Maybe it's just me, but my devices end up being numbered the same after
> every reboot. Unless I add or remove devices to/from the system, of course.

Sure, that works fine for most things, and will continue to do so. But
there are entire subsystems in the kernel, mostly newer ones, which do
not have any static number assignment and require dynamic /dev
support.

It's not about /dev/null and /dev/tty and such, that will not change,
but there is already an option in the upstream kernel to assign
dynamic numbers to sd* disks to allow more than 15 partitions, and the
numbers of subsystem requiring dynamic numbers will likely grow.

The thing today is that userspace on distro systems messes around in
/dev and assigns access control lists to grant device-access to
specific users, udev creates many symlinks there to identify your
devices, because the kernel names get reordered, and nothing will ever
revert /dev to the state where it came from at boot.
    So the wider support for a static /dev is kind of fading away,
stuff that works today statically will likely continue to work, but
all the new stuff will not work with a static /dev. That's one part of
what devtmpfs addresses.

Thanks,
Kay
