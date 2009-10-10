Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbZJJV4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbZJJV4k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 17:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbZJJV4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 17:56:39 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:62190 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbZJJV4i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 17:56:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mh3DtVWudqAOkuuTcdgX/4KSV74cMn9l+kX3q+UwEWZtyrXM6G1FfXVsyWqYdxMhnJ
         gytZBH9htoAe3S7sQaoLSUd9zpWI2Ob22HJyLe4C7hs9Gr05Z32SqWHUyHs0NkZsG3/v
         +9wXCRZoKXK+AfY+DHqD++ODkQIDjQ56LsGbQ=
MIME-Version: 1.0
In-Reply-To: <200910102347.04579.rjw@sisk.pl>
References: <20091010213722.051a60dc@mosly>
	 <1255210017.3692.24.camel@maxim-laptop>
	 <200910102347.04579.rjw@sisk.pl>
Date: Sun, 11 Oct 2009 07:56:01 +1000
Message-ID: <21d7e9970910101456m277a3c31k3a1add039fcae9d6@mail.gmail.com>
Subject: Re: [Intel-gfx] [bisected] i915: linux-2.6.32-rc3+ regression
From: Dave Airlie <airlied@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Sergei Trofimovich <slyich@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 7:47 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday 10 October 2009, Maxim Levitsky wrote:
>> On Sat, 2009-10-10 at 21:37 +0300, Sergei Trofimovich wrote:
>> > Hi!
>> >
>> > After syncing git tree to bd381934bf13ccb1af2813ae26c6fe00ec85d254
>> > I've experienced pixel color corruption in Xorg.
>> > Some of pixels (not all) have abnormal colors seen on images like this:
>> > http://trofimeus.narod.ru/2009-10-09-22-00-17.png [1.5M]
>> > (you won't see any problem until you run -rc3+ kernel).

Are you running X.org server 1.7 + driver? if so there is a bug in the current
released driver between that combination, the fix is on the intel-gfx
mailing list.

The 1.6 X server + same driver doesn't show this problem.

Dave.

>> >
>> > I've bisected it[2] and found offending commit[1].
>> > My hardware is HP Compaq 2510p laptop:
>> > 00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
>> >
>> > Do you need more info?
>> >
>> > Thanks!
>> >
>> > [1] offending commit
>> > > 068143d38804825d59d951a192cfadd2e22f457d is the first bad commit
>> > > commit 068143d38804825d59d951a192cfadd2e22f457d
>> > > Author: Dave Airlie <airlied@redhat.com>
>> > > Date:   Mon Oct 5 09:58:02 2009 +1000
>> > >
>> > >     drm/fb: add setcmap and fix 8-bit support.
>> > >
>> > >     This adds support for the setcmap api and fixes the 8bpp
>> > >     support at least on radeon hardware. It adds a new load_lut
>> > >     hook which can be called once the color map is setup.
>> > >
>> > >     Signed-off-by: Dave Airlie <airlied@redhat.com>
>> >
>> > [2] bisect log:
>> > :040000 040000 9334e1ee9d528eaa5babd419bd53b40417e65f0f 7e06eb50488482efd38ac243080c9f27ee8682ec M   drivers
>> > :040000 040000 31c8cb95831669746c0ee2ff8e34d15dc6c49b0e 0523107fc14ca0bb6914b93ea56dab20c741d61c M   include
>> > git bisect start
>> > # bad: [bd381934bf13ccb1af2813ae26c6fe00ec85d254] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rol
>> > and/infiniband
>> > git bisect bad bd381934bf13ccb1af2813ae26c6fe00ec85d254
>> > # good: [374576a8b6f865022c0fd1ca62396889b23d66dd] Linux 2.6.32-rc3
>> > git bisect good 374576a8b6f865022c0fd1ca62396889b23d66dd
>> > # bad: [1c6e6d91b22c4271e8a5dab559a08cb005a77073] Merge branch 'drm-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/air
>> > lied/drm-2.6
>> > git bisect bad 1c6e6d91b22c4271e8a5dab559a08cb005a77073
>> > # good: [d8e7b2b3ac5319fcee616488c628c2bbe7e2937b] Merge branch 'omap-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/ke
>> > rnel/git/tmlind/linux-omap-2.6
>> > git bisect good d8e7b2b3ac5319fcee616488c628c2bbe7e2937b
>> > # good: [185974dd596e67e73906790c2a4a4579d75911e6] drm: Delete the DRM_DEBUG_KMS in drm_mode_cursor_ioctl
>> > git bisect good 185974dd596e67e73906790c2a4a4579d75911e6
>> > # bad: [01ceae8edd7a0a6d8588dc103ad9f55e2c52cae9] drm/radeon/kms: Fix RS600/RV515/R520/RS690 IRQ
>> > git bisect bad 01ceae8edd7a0a6d8588dc103ad9f55e2c52cae9
>> > # bad: [b8c00ac5b50b54491657f8b6740db1df50149944] drm/fb: add more correct 8/16/24/32 bpp fb support.
>> > git bisect bad b8c00ac5b50b54491657f8b6740db1df50149944
>> > # bad: [068143d38804825d59d951a192cfadd2e22f457d] drm/fb: add setcmap and fix 8-bit support.
>> > git bisect bad 068143d38804825d59d951a192cfadd2e22f457d
>> > # good: [dfee5614e4d83a32cef9193a8b19bc1d8900f93d] drm/radeon/kms: respect single crtc cards, only create one crtc. (v2)
>> > git bisect good dfee5614e4d83a32cef9193a8b19bc1d8900f93d
>> >
>> >
>> > _______________________________________________
>> > Intel-gfx mailing list
>> > Intel-gfx@lists.freedesktop.org
>> > http://lists.freedesktop.org/mailman/listinfo/intel-gfx
>>
>>
>> I found that today too.
>> I had filled a bugreport.
>> https://bugs.freedesktop.org/show_bug.cgi?id=24444
>
> Would you please notify me about _kernel_ regression reports filed at
> freedesktop.org?
>
> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
