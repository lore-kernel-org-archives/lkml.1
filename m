Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0CEIQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 03:16:38 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:45993 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab0CEIQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 03:16:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v6xUEnidJWQERFe6YMvskCKmlIPxGlagwwvSQ0Cj8M4Vjzr+PafS4L6A21TfSq+n/G
         RKsPTHXPR9AfOG7AqU0/FSnmShpnGlJv1BgluUwWlGfDl79nk1YB3jKuATRHGXBTvINp
         eVsc7guNVMIIN9FdJMgqTRpREp8Sfx9irS1sE=
MIME-Version: 1.0
In-Reply-To: <20100305074407.GC19703@elte.hu>
References: <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
	 <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>
	 <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
	 <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
	 <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>
	 <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>
	 <1267748927.3496.6.camel@nisroch> <20100305064955.GA6453@elte.hu>
	 <84144f021003042306w2e017efbva2be364c1c4980a7@mail.gmail.com>
	 <20100305074407.GC19703@elte.hu>
Date: Fri, 5 Mar 2010 00:16:35 -0800
Message-ID: <6a89f9d51003050016l16343417od6bdd90abfafd53d@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Stephane Marchesin <stephane.marchesin@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ben Skeggs <skeggsb@gmail.com>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, dri-devel@lists.sf.net,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 23:44, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>
>> On Fri, Mar 5, 2010 at 8:49 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> > The conclusion is crystal clear, breaking an ABI via a "flag day"
>> > cleanup/feature/etc is:
>> >
>> > ?- wrong
>> >
>> > ?- harmful
>> >
>> > ?- limits the developer base
>> >
>> > ?- limits the tester base
>> >
>> > ?- wastes time and effort. (fewer developers/testers means that while _this_
>> > ? feature was easier to add, all your _future_ features will be a bit harder
>> > ? to do. It compounds up.)
>> >
>> > ?- so it hurts even the very developer who is most convinced that this was the
>> > ? right thing to do
>> >
>> > It's a bad technical decision throughout. It's masochistic and often suicidal
>> > to just about any project in essence. I've seen projects that did it once and
>> > died just due to that single act of stupidity. I've seen projects that have
>> > done it a few times and took the usage hit, limped along with the wounds and
>> > never grew to the size they could have achieved. I've seen projects that did
>> > it once, took the hit, learned from it and never did it again.
>>
>> Agreed. What bothers me in this discussion is that people keep bringing up
>> the fact that nouveau is mostly developed by volunteers and thus it doesn't
>> make sense to make sure it's backwards (or forwards) compatible. But the way
>> I see it, it's the complete opposite. It's _more_ important to support ABIs
>> for community-driven efforts because you're relying on people who by
>> definition don't have time to waste. While the nouveau people might have
>> good intentions, I'm afraid they might be severely limiting their developer
>> and tester base because they're not focused on real world problems (like the
>> ones Linus is seeing).
>
> Yeah. I've seen a few other bad arguments as well:
>
>   'exploding test matrix'
>
> This is often the result of _another_ bad technical decision:
> over-modularization.
>
> Xorg, mesa/libdrm and the kernel DRM drivers pretty share this signature:
>
>  - it's developed by the same tightly knit developer base who often cross
>   between these packages. Features often need changes in each component.
>
>  - a developer to be able to do real work has to have the latest sources
>   of all these components.
>
>  - a user just uses whatever horizontal version cut the distro did and never
>   truly 'mixes' these components as a conscious decision.
>
>  - distros just try to get the latest and most capable but still stable
>   version. Desperately so. Often they will create a version mix that was
>   never tested by developers in that form. They'll expose users to ABI
>   combinations that were never really intended. They have trouble
>   bootstrapping and stabilizing those essentially random combinations and
>   then have trouble applying stability and security fixes.
>
> The thing is, if development has such characteristics then it's pretty clearly
> not 3-4 separate projects but _one_ abstract project. [*]
>
> So the 'exploding test matrix' is simply the result of: creating ABIs between
> 3-4 _artificial components of the same project_ and then going through
> developer hell living with that mistake. [**]
>
> It's a bit as if we split up the kernel into 'microkernel' components, did a
> VFS ABI, MM ABI, drivers ABI, scheduler ABI, networking ABI and arch ABIs, and
> then tried to develop them as separate components.
>
> If we did then then Linux kernel development would slow down massively while
> in reality everyone would _still_ have to have the latest and greatest source
> checked out to do some real development work and to be able to implement
> features that affect the whole kernel ...
>
> Linux would become an epic fail of historic proportions if we ever did that.
>

Yes that is exactly the problem we are facing. And you know what? All
graphic driver devs agree on that, but there is no obvious solution.

Here are the interfaces which are part of this problem:
- drm interface (drm wrappers as seen from the driver, drm ioctls from
the user space)
- X.Org acceleration interface (EXA and friends as seen from the
driver, XRender and friends as seen from the apps)
- Mesa interface (Gallium or mesa driver interface from the driver,
OpenGL seen from the app)

Any solution will involve merging two or more components together to
remove interfaces, so lets observe pairwise what could be merged and
the drawbacks:
- Merge DRM and Mesa drivers. Technically we could do this, but then
what happens when a new OpenGL version/feature comes around? Yes, we
get a new mesa interface. So we're exchanging one interface for
another here. No gain.
- Merge DDX And DRM driver. Same problem as before, whenever 2D
interfaces changes, we have to update the DDX anyway. Again, no gain
in sight.
- Merge Mesa and DDX drivers. This makes sense, and this is where
gallium is going by providing 2D and GL acceleration on top of a
single, common gallium driver. So yes, I have hopes that this one will
happen eventually, at least on non-intel hardware.

In a far away future, I can only hope that all acceleration (2D and
3D) will be done on top of GL only. That'll mean we can remove the DDX
entirely. We've been talking about this for 6 years or so. But as you
know, it's far from the case yet.

Stephane
