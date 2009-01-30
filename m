Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbZA3BRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbZA3BRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 20:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbZA3BRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 20:17:30 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:58050 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbZA3BR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 20:17:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V4dgs+aIeR+Pg6iQZmkkF8j2k1kkwtkr02/3mYRCfKidQUebSfncEAVgdVFN700jTc
         Benalr40DUOk9H/WftZvSIrlCVe2klrUHTAiBaQCtLKtG07eEMFMgHxqhdhrJP8FDAVB
         SRFONsZdZfBsRXbMy2wU7qGgYXv9b/nlZY8kg=
MIME-Version: 1.0
In-Reply-To: <21d7e9970901291706t17fc3d9aq753f90db75396639@mail.gmail.com>
References: <a6f8318b0901210358w7cced8e9yab86c487b3587d75@mail.gmail.com>
	 <a6f8318b0901210427o33af879byd352adaf5fde1c29@mail.gmail.com>
	 <20090129163032.f97901c5.akpm@linux-foundation.org>
	 <21d7e9970901291706t17fc3d9aq753f90db75396639@mail.gmail.com>
Date: Thu, 29 Jan 2009 17:17:28 -0800
Message-ID: <91705d080901291717r74ace12ex7cba426f7879b333@mail.gmail.com>
Subject: Re: PROBLEM: kernel BUG at drivers/gpu/drm/drm_fops.c:146!
From: Dan Nicholson <dbn.lists@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, kerolasa@iki.fi,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       dri-devel@lists.sourceforge.net, kerolasa@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 5:06 PM, Dave Airlie <airlied@gmail.com> wrote:
> On Fri, Jan 30, 2009 at 10:30 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> (cc's added)
>>
>> On Wed, 21 Jan 2009 13:27:48 +0100
>> Sami Kerola <kerolasa@iki.fi> wrote:
>>
>>> I compiled the Torvalds git kernel 2.6.29-rc2-00013 and I got an oops.
>>> The oops happens when ever X starts. Initially I was booting with run
>>> level 5 and it hung. I tried to use run level to 3 and an operating
>>> system started just fine. When I type startx the hung happen again.
>>> Please let me know if you need some more information besides oops from
>>> messages file and lspci output.
>>>
>>>
>>> Jan 21 08:53:58 lelux kernel: ------------[ cut here ]------------
>>> Jan 21 08:53:58 lelux kernel: kernel BUG at drivers/gpu/drm/drm_fops.c:146!
>>
>> I assume that 2.6.28 didn't do this?
>
> This is a userspace race between udev and libdrm, I'm not sure we can do
> anything in the kernel other than BUG, maybe we should just WARN instead.
>
> Basically, libdrm creates devices nodes, the initial drm opening gets that, udev
> comes along when the module is loaded and re-creates the device node,
> when AIGLX opens the device
> it can't figure out wtf just happened, as the inode->i_mapping we use
> to store the GEM device mmap ranges is different.
>
> I think building libdrm with --enable-udev is the correct answer, and
> maybe switching this to a WARN so it doesn't blow up.

Hi Dave,

I really think libdrm should have --enable-udev on by default for
linux. The number of people not using udev for managing their devices
is surely in the minority now. What do you think?

--
Dan
