Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbZJ1CxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbZJ1CxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 22:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932101AbZJ1CxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 22:53:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37349 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075AbZJ1CxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 22:53:16 -0400
To: Dave Airlie <airlied@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       DRI Development Mailing List 
	<dri-devel@lists.sourceforge.net>,
       Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>
Subject: Re: is avoiding compat ioctls possible?
From: Andi Kleen <andi@firstfloor.org>
References: <21d7e9970910271822p3751b2fdnd78e1bc3326b9b0b@mail.gmail.com>
Date: Wed, 28 Oct 2009 03:53:17 +0100
In-Reply-To: <21d7e9970910271822p3751b2fdnd78e1bc3326b9b0b@mail.gmail.com> (Dave Airlie's message of "Wed, 28 Oct 2009 11:22:18 +1000")
Message-ID: <87hbtkjkki.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie <airlied@gmail.com> writes:

> They used uint64_t to represent userspace pointers and userspace
> casted into those and the kernel casts back out and passes it to copy_*_user

uint64_t is actually dangerous due to different alignment on x86-32 vs 64,
better use compat_u64/s64

> Now I thought cool I don't need to worry about compat ioctl hackery I can
> run 32 on 64 bit apps fine and it'll all just work.
>
> Now Dave Miller points out that I'm obivously deluded and we really need
> to add compat ioctls so that the kernel can truncate correctly 32-bit address
> in case userspace shoves garbage into the top 32bits of the u64.

When the user space sees a u64 field it should never shove garbage here.
You just have to cast on 32bit for this, which is a bit ugly.

However some architectures need special operations on compat pointers
(s390 iirc), but if you don't support those it might be reasonable
to not support that.

> Is there really no way to avoid compat ioctls? was I delusional in
> thinking there was?

Experience shows that people make mistakes and you sooner or
later need them anyways to work around them.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
