Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbZFOEju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbZFOEju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 00:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbZFOEji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 00:39:38 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:3822 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055AbZFOEjh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 00:39:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=W+AyucNmIgsn+YZbgH5QmgZuWS8n6Dx5lKkg1TaXuzLH5s6SHZdNPEKOKlhMllqzxW
         /q9v8gZu7Biw+FRfkOM2nH0PEwonSoTZJdwVI+3tQF6VkIjrDTQ6CzK8PJ/jhpgeXmyn
         e22nBcKzFXeIff8Otf5osQn/TRMN/X5c7i5XM=
MIME-Version: 1.0
In-Reply-To: <20090615043716.GA9900@uranus.ravnborg.org>
References: <8bd0f97a0906081623h4dc26492kd70c2e07091730d@mail.gmail.com> 
	<20090614204437.GC3187@uranus.ravnborg.org> <200906142159.42280.rgetz@blackfin.uclinux.org> 
	<8bd0f97a0906141905m54958c02l3cae598d0136980b@mail.gmail.com> 
	<20090615043716.GA9900@uranus.ravnborg.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 15 Jun 2009 00:39:19 -0400
Message-ID: <8bd0f97a0906142139h4fad76e8s98130ffa438523b5@mail.gmail.com>
Subject: Re: [kbuild-devel] scripts/kallsyms: extending region checking for 
	Blackfin memory regions
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>,
       kbuild-devel@lists.sourceforge.net,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 00:37, Sam Ravnborg wrote:
> On Sun, Jun 14, 2009 at 10:05:26PM -0400, Mike Frysinger wrote:
>> On Sun, Jun 14, 2009 at 21:59, Robin Getz wrote:
>> > On Sun 14 Jun 2009 16:44, Sam Ravnborg pondered:
>> >> On Mon, Jun 08, 2009 at 07:23:16PM -0400, Mike Frysinger wrote:
>> >> > intro: the current Blackfin memory architecture is (1) no virtualized
>> >> > memory and (2) distinctly harvard.  that means we cannot create a
>> >> > linear map of start/end text sections.  we end up with distinct
>> >> > regions like so:
>> >> > 00001000 T __stext
>> >> > 000dc4c0 T __etext
>> >> > feb00000 A __etext_l2
>> >> > feb00010 A __stext_l2
>> >> > ffa00000 T __stext_l1
>> >> > ffa0160c T __etext_l1
>> >> > this is because external memory starts at address 0 while on-chip
>> >> > regions have different discontiguous hardcoded addresses (L1
>> >> > instruction in this case starts at 0xffa00000 while L2 starts at
>> >> > 0xfeb00000).
>> >> >
>> >> > the current kallsyms is written to search for the special stext/etext
>> >> > symbols only which means the resulting kallsyms output knows nothing
>> >> > of the Blackfin symbols living in these on-chip regions.  we've
>> >> > written two patches to fix this: the first one is straight forward and
>> >> > simply copies & pastes the existing hardcoded regions.  the second
>> >> > creates an array of text regions which makes it much easier to extend
>> >> > in the future for other people (and can be squashed into the first
>> >> > one).
>> >> >
>> >> > doesnt matter to me which method is picked :)
>> >>
>> >> I added both as I liked the generalization.
>> >> I had to rearrange the "Signed-off-by" in the first patch
>> >> as this patch came in vai you and not Robin.
>> >
>> > I think Mike pulled this from some work I did awhile ago, (and sent to you)
>> > that obviously never got added (since I didn't send it in the proper patch
>> > format).
>> >
>> > http://lkml.indiana.edu/hypermail/linux/kernel/0607.1/0558.html
>>
>> yeah, the first patch was by Robin ... the "From:" line in the patch
>> should have shown that (and git-am would have respected) ...
>
> So does the patch.
> What I had to change was that the Signed-off-by: lines indicated
> that this patch came in like this:
>
> Robin -> Mike -> Bryan Wu -> Sam
> So I rearranged the signed-off-by: lines so it indicated
> the following order:
>
> Robin -> Bryan Wu -> Mike -> Sam
>
>
> I trust that Bryan really did add his sob, and it
> was only a mistake that Mike added his sob before
> that of Bryans.

yes, i took a bunch of patches from Bryan like this one
-mike
