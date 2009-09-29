Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbZI2Jbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbZI2Jbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 05:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbZI2Jbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 05:31:40 -0400
Received: from mail-pz0-f191.google.com ([209.85.222.191]:64816 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbZI2Jbk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 05:31:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wwFHH2ZIXCxH/dlmYbBCPmhKnRTIExszq5P2aNHAQYFJY3s6o3ijnhd+7/8KJOrhXU
         5pKXxbIvdA8vGlFcI021jChlb6hWc81iExdUCdjWhir0zmrFpymtdi+PpXOI7AToRdLm
         hd5nmrwHInRmXJTEo58LsbDiP/K1TNd8b9b2o=
MIME-Version: 1.0
In-Reply-To: <20090929072454.GA11414@elte.hu>
References: <8db1092f0909270105x4b49daf8k268e453d2379020c@mail.gmail.com>
	 <2674af740909270127s464a3cb2xef5e7f4cd61b0eb7@mail.gmail.com>
	 <20090929072454.GA11414@elte.hu>
Date: Tue, 29 Sep 2009 17:31:43 +0800
Message-ID: <2674af740909290231m5af0fbc6t5fba0b127c63bd9f@mail.gmail.com>
Subject: Re: [2.6.31-git17] WARNING: at kernel/hrtimer.c:648 
	hres_timers_resume+0x40/0x50()/WARNING: at drivers/base/sys.c:353 
	__sysdev_resume+0xc3/0xe0()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 3:24 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yong Zhang <yong.zhang0@gmail.com> wrote:
>
>> On Sun, Sep 27, 2009 at 4:05 PM, Maciej Rutecki
>> <maciej.rutecki@gmail.com> wrote:
>> > Kernel: 2.6.31-git17
>> >
>> > During suspend to disk & resume I got it in dmesg:
>> >
>> > [  587.940010] ------------[ cut here ]------------
>> > [  587.940010] WARNING: at kernel/hrtimer.c:648 hres_timers_resume+0x40/0x50()
>> > [  587.940010] Hardware name: HP Compaq nx6310 (EY501ES#AKD)
>> > [  587.940010] hres_timers_resume() called with IRQs enabled!
>> > [  587.940010] Modules linked in: btusb i915 drm_kms_helper drm
>
> Could you try this with .32-rc1? This commit should have fixed the
> message above:
>
> 89133f9: clocksource: Resume clocksource without taking the clocksource mutex
>

Hi Ingo,

Indeed, Maciej said this issue is gone with .32-rc1. But I don't think
this is the same
issue with 89133f9 because in this one timekeeping_resume() is called
with irq enabled.
This is very odd and the bug exists in other parts.

Thanks,
Yong

>        Ingo
>
