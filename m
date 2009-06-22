Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZFVAFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZFVAFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 20:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754279AbZFVAFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 20:05:36 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:35177 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbZFVAFg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 20:05:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=E9VO7ablcqmROGADmwUTY53o0WAoSBxCJ0oTi1jMGjtlt3Se44v6M6W7/SN9SSGqoL
         cjmqnwvQngd78BWplUL4FwBOSz7fmZeqpwkxC9XhkOx6LQThROIoekzfr6cm0aDx4fiZ
         oRV36SOnyVvTbvkPYcHzEJgZfpFXtd49T/iDg=
MIME-Version: 1.0
In-Reply-To: <cb0375e10906211414j390fc590y4331896bddda9c0d@mail.gmail.com>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	 <4A3DABE1.50309@mit.edu>
	 <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
	 <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
	 <alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
	 <cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com>
	 <alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
	 <cb0375e10906211414j390fc590y4331896bddda9c0d@mail.gmail.com>
Date: Sun, 21 Jun 2009 20:05:36 -0400
X-Google-Sender-Auth: 18aa8c1888e35849
Message-ID: <cb0375e10906211705q382f5211lf09e39ff637c1c0d@mail.gmail.com>
Subject: Re: [git pull] drm: previous pull req + 1.
From: Andrew Lutomirski <luto@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.sf.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jerome Glisse <jglisse@redhat.com>,
       Alex Deucher <alexdeucher@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 21, 2009 at 5:14 PM, Andrew Lutomirski<luto@mit.edu> wrote:
> On Sun, Jun 21, 2009 at 3:47 PM, Linus
> Torvalds<torvalds@linux-foundation.org> wrote:
>>
>>
>> What *has* changed is that we have a newradeon driver, and it looks like
>> that new radeon driver is crap, and does this:
>>
>>        info->fix.smem_start = (unsigned long)fbptr;
>>
>> which is totally screwed up. It assigns a _virtual_ address to that
>> "smem_start" thing, even though it should be a physical one.
>>
>> I don't know the radeon driver, so I don't know where to find the physical
>> address.  It's also possible that there is no good single physical
>> address, and the radeon driver should implement a "fb_mmap" function.
>>
>> Does this patch make the warning and the oops at least go away? Obviously
>> it won't result in a working frame buffer, but that's a separate issue
>>
>
> I haven't tried your patch, but I hacked up the one below instead,
> which also fixes the oops.  It still doesn't boot, though -- plymouth
> hangs (or otherwise dies), preventing my initramfs from finishing.
> The same kernel image boots fine with radeon.modeset=0.

My patch is no good -- plymouthd just dies more silently with it.
Returning -EINVAL from radeonfb_mmap prevents plymouthd's splash
screen from working (of course) but lets the system boot.  (Not only
does the system boot, but this is the first modesetting kernel I've
ever seen work on this hardware.)  Linus's patch works and even lets
me start X.

David -- there are still plenty of bugs.  The kernel gets my monitor's
resolution wrong (X reads it off DDC correctly but I have to use
xrandr to force the resolution).  And glxgears triggers the kernel's
command verification and dies.  But this is still a huge improvement
over modesetting on the F11 kernel, which is unusable for me (image is
garbled beyond recognition once I start X).

--Andy
