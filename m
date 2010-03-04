Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab0CDVW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:22:57 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:62712 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab0CDVWz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:22:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y1mhik8PVtWd4jA8mItm/6shni8I4kbfNhXElm97jPRgDSQKLcg155CNmeoW+Abafu
         3H2L692G2a/jGQkn1gSywe5E5uALyX/MJu74s4MIvEIk58ILqrw6/YfxYNOL7bF48Fhe
         JcIS5wJqp2qQV5Fv+Qmx4foWDUvGBetmunAMA=
MIME-Version: 1.0
In-Reply-To: <6d4bc9fc1003041321g4190a4b4na665560a494877b0@mail.gmail.com>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
	 <6d4bc9fc1003041321g4190a4b4na665560a494877b0@mail.gmail.com>
Date: Thu, 4 Mar 2010 22:22:53 +0100
Message-ID: <6d4bc9fc1003041322s3a3acfecs53dc08f553838efa@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Maarten Maathuis <madman2003@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 10:21 PM, Maarten Maathuis <madman2003@gmail.com> wrote:
> On Thu, Mar 4, 2010 at 7:18 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>>
>> Hmm. What the hell am I supposed to do about
>>
>>        (II) NOUVEAU(0): [drm] nouveau interface version: 0.0.16
>>        (EE) NOUVEAU(0): [drm] wrong version, expecting 0.0.15
>>        (EE) NOUVEAU(0): 879:
>>
>> now?
>>
>> What happened to the whole backwards compatibility thing? I wasn't even
>> warned that this breaks existing user space. That makes it impossible to
>> _test_ new kernels. Upgrading X and the kernel in lock-step is not a valid
>> model, lots of people are just using some random distribution (F12 in my
>> case), and you just broke it.
>>
>> I see the commit that does this was very aware of it:
>>
>>        commit a1606a9596e54da90ad6209071b357a4c1b0fa82
>>        Author: Ben Skeggs <bskeggs@redhat.com>
>>        Date:   Fri Feb 12 10:27:35 2010 +1000
>>
>>            drm/nouveau: new gem pushbuf interface, bump to 0.0.16
>>
>>            This commit breaks the userspace interface, and requires a new libdrm for
>>            nouveau to operate again.
>>
>>            The multiple GEM_PUSHBUF ioctls that were present in 0.0.15 for
>>            compatibility purposes are now gone, and replaced with the new ioctl which
>>            allows for multiple push buffers to be submitted (necessary for hw index
>>            buffers in the nv50 3d driver) and relocations to be applied on any buffer.
>>
>>            A number of other ioctls (CARD_INIT, GEM_PIN, GEM_UNPIN) that were needed
>>            for userspace modesetting have also been removed.
>>
>>            Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
>>            Signed-off-by: Francisco Jerez <currojerez@riseup.net>
>>
>> but why the hell wasn't I made aware of it before-hand? Quite frankly, I
>> probably wouldn't have pulled it.
>>
>> We can't just go around breaking peoples setups. This driver is, like it
>> or not, used by Fedora-12 (and probably other distros). It may say
>> "staging", but that doesn't change the fact that it's in production use by
>> huge distributions. Flag days aren't acceptable.
>>
>>                Linus
>>
>> ------------------------------------------------------------------------------
>> Download Intel&#174; Parallel Studio Eval
>> Try the new software tools for yourself. Speed compiling, find bugs
>> proactively, and fine-tune applications for parallel performance.
>> See why Intel Parallel Studio got high marks during beta.
>> http://p.sf.net/sfu/intel-sw-dev
>> --
>> _______________________________________________
>> Dri-devel mailing list
>> Dri-devel@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/dri-devel
>>
>
> What i'm about to say is my personal opinion, not that of nouveau as a
> whole (not even sure if such a thing exists).
>
> 1. We are in staging because our abi isn't final yet.
> 2. We (already) adjusted our way of working to ensure we have a usable
> and proper codebase by the time we are ready for mainline.
> 3. Redhat through Ben Skeggs contributes to nouveau (quite a bit i agree).
> 4. You are forcing red hat to force something on the rest of us.
> 5. I for one am happy we keep a clean api.
> 6. We keep an internal kernel tree that is tested to some degree (in
> this case the abi break was in there for a few weeks iirc) none of the
> developers asked for a revert.

Point 6 is iirc, someone can correct me if this is not the case.

> 7. Everyone (users, distros) are (or should) be aware of the nature of
> this driver, our userspace interface is experimental for that very
> reason.
> 8. Experience has tought me that in the case of nouveau, if a
> developer isn't using a codepath it will bitrot.
>
> So please, also take into consideration that this project isn't solely
> made by red hat and it's usually the other people that get to keep the
> pieces.
>
> Sincerely,
>
> Maarten Maathuis.
>
