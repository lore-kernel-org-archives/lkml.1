Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab0BDIsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:48:12 -0500
Received: from mail-iw0-f189.google.com ([209.85.223.189]:53853 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab0BDIsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:48:07 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Feb 2010 03:48:07 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D/8bCcA0NUiEvkVhhnBjDyO051eotW+jYNtu+jo7XeZoxQxCnQtRiiLcbiREcoWnkP
         NgbWakRBUxzcjtqOakSPcVS6Bbdv7uOqLzHJvg7dc+Qpl8gc5ZmWU0Zzb+/4BhygMQfL
         GMJbiaSamsY/xNWEKMovZOWKXsdOaDyJl7MOs=
MIME-Version: 1.0
In-Reply-To: <4B6A8278.8070001@kernel.org>
References: <20100204012837.GC538@hexapodia.org>
	 <20100204075642.GA28286@hexapodia.org> <4B6A8278.8070001@kernel.org>
Date: Thu, 4 Feb 2010 18:40:55 +1000
Message-ID: <21d7e9971002040040w5910357j1a4b35ec256728b@mail.gmail.com>
Subject: Re: [2.6.33-rc6-git regression] idr fix breaks Xorg
From: Dave Airlie <airlied@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andy Isaacson <adi@hexapodia.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 4, 2010 at 6:16 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 02/04/2010 04:56 PM, Andy Isaacson wrote:
>> 1265267921.568269 ioctl(8, 0xc020645e, 0x7fffe2196980) = -1 EBADF (Bad file descriptor)
>
> Hmm... -EBADF?  I suppose it doesn't mean that the fd is invalid in
> this case but that the mapped object can't be found for some reason?
> Can anyone more familiar with the subsystem explain what's going on?
>
>> 1265267921.568649 write(2, "../../../libdrm/intel/intel_bufmgr_gem.c:637: Error mapping buffer 1073741824 (gen4 WM state): Bad file descriptor .\n", 117) = 117
>> 1265267921.569039 --- SIGSEGV (Segmentation fault) @ 0 (0) ---
>
> I'll forward the fore mentioned fix as it at least fixes one reported
> failure.

Hmm at this late stage, maybe revert first? since the old idr code works fine
with the subsystems in question.

The drm idr code usage isn't anything crazy, the EBADF is the return code
from the mmap ioctl when it calls the idr lookup function for a handle.

The lookup function is just an idr_find inside a spinlock.

Dave.
