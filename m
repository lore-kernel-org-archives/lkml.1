Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab0BDSan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:30:43 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:48871 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471Ab0BDSal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:30:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rFu1od8+L2vz57N8uJaWrKG+2kVqTRhOBBER0T82Ptz0AX7W4lBWalSo+J6sxZz+sm
         9EUYTpk7pJpLS0DJTRLWvEvTBQWV+joOF9edRS9AUd6f7KuSRrZ0eG4sa/rACuBa6ELp
         hWOb6cJd0yALCQ3QXP24ZC1cfggFtQy7+1eJs=
MIME-Version: 1.0
In-Reply-To: <20100204181218.GA6175@elte.hu>
References: <21d7e9971002020035v22318962w6412ccd8d93449da@mail.gmail.com>
	 <21d7e9971002021234y275fae02k410af92bb16fee73@mail.gmail.com>
	 <20100204062619.GA29154@elte.hu> <20100204071705.GA28403@elte.hu>
	 <20100204164859.GA17878@srcf.ucam.org>
	 <20100204170826.GA16397@elte.hu>
	 <20100204173602.GA19855@srcf.ucam.org>
	 <20100204175445.GB27361@elte.hu>
	 <20100204175928.GA20595@srcf.ucam.org> <20100204181218.GA6175@elte.hu>
Date: Thu, 4 Feb 2010 13:30:37 -0500
Message-ID: <a728f9f91002041030o7c8d38edxe573bc0a1327d79@mail.gmail.com>
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch 
	out of staging."
From: Alex Deucher <alexdeucher@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 4, 2010 at 1:12 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
>> On Thu, Feb 04, 2010 at 06:54:45PM +0100, Ingo Molnar wrote:
>>
>> > But you could claim that it's not a regression because 1) technically the
>> > code got introduced in drivers/staging/, and staging drivers are not on
>> > the regression list 2) the Kconfig value is default-off so it can only
>> > harm those who got lured by a new Kconfig value popping up in -rc7 in a
>> > well working driver they already have enabled.
>> >
>> > So the moving of driver functionality from drivers/staging/ to drivers/
>> > is a grey area it appears. Wouldnt it have been better to do this in the
>> > next merge window, as all other drivers do? It's not new hardware
>> > enablement either, it's feature enablement for an existing driver.
>>
>> The reason the option was in staging (as has been mentioned before) was
>> because the ABI wasn't felt to be stable enough. Upstream is now willing to
>> commit to that stability, so now seems as good a time to move it as any.
>> There's no code change and there's no default configuration change, so I
>> really can't see any way that it can be classed as a regression.
>
> But that argument in essence renders the regression policy meaningless for
> such code: just about any new driver feature under the sun could be shaped as
> a Kconfig option, introduced via a drivers/staging Kconfig entry, and then
> activated via a twoliner commit in a later -rc.
>
> IMHO the point of tracking regressions is to reduce the bugginess of the
> kernel and thus to help users, not to give ground for legalistic arguments.
>
> There _are_ common-sense exceptions from the regression rules, such as the
> introduction of a new piece of hardware that was previously unsupported
> (hence there's no expectation of stability) - but the tweaking of an
> existing, widely used driver (even if the new opion is default-off) hardly
> seems to qualify for that.
>

This is a completely new driver.  It's only part of the existing drm
for compatibility reasons.  It requires an entirely different graphics
stack above it and works very differently from the old drm stack.

Alex

> I dont mind making useful exceptions from rules, as long as we are honest
> about having done it.
>
> Anyway, i've bisected it back to that Kconfig change and i am able to work
> the crashes around by reverting that, so my immediate problems are solved.
>
> Thanks,
>
>        Ingo
>
> ------------------------------------------------------------------------------
> The Planet: dedicated and managed hosting, cloud storage, colocation
> Stay online with enterprise data centers and the best network in the business
> Choose flexible plans and management services without long-term contracts
> Personal 24x7 support from experience hosting pros just a phone call away.
> http://p.sf.net/sfu/theplanet-com
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>
