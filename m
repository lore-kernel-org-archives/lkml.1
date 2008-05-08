Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbYEHNHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbYEHNHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758715AbYEHNHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:07:37 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:21616 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758783AbYEHNHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:07:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IIymWOS7bYxTsEGa/+gRQqHXxBuqs2eIzGdJD902Vp/Bsod6FLEM+9Jj6WQEWOCtuscP4NW8nJyETOKJHuosLW6/ZtDD5OTajcv/WHurMRpAcIaV5ywE5dvygC96L3FF5/3p++ASR+pcVgszX9eMnCYM3SesovvpcsiEmCUWzEE=
Message-ID: <58cb370e0805080607n4f5de192o5a7371fd0fb1e9f8@mail.gmail.com>
Date: Thu, 8 May 2008 15:07:31 +0200
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "TAKADA Yoshihito" <takada@mbf.nifty.com>
Subject: Re: kernel 2.6.25 with ide driver cs5520 does not boot.
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20080508.165814.197343623.takada@mbf.nifty.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080508.165814.197343623.takada@mbf.nifty.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 8, 2008 at 9:58 AM, TAKADA Yoshihito <takada@mbf.nifty.com> wrote:
> HI, all.
>  (please CC to me, I'm not on LKML)
>
>  kernel 2.6.25 with ide driver cs5520 does not boot.
>
>  Attached part of dmesgs as dmesgs.txt

CS5520 is a bit special hardware because it doesn't support "normal"
DMA but Virtual DMA (PIO transfers between device<->host but DMA
transfers between host<->CPU).  In 2.6.25 we added support for Virtual
DMA to cs5520 host driver so it could be it (till 2.6.25 PIO has always
been used - the info printed by kernel about PIO/DMA BIOS settings was
misleading/bogus so it got removed altogether in 2.6.26-rc1).

I'll double-check the code and datasheet/errata that we don't miss
something important for proper Virtual DMA support (and if not than
I guess that we need to disable this feature for now).

In the meantime please try 2.6.26-rc1 (just to be sure that the
problem was not caused by something else that got fixed already).

>  kernel 2.6.23 with cs5520 is works correct. cs5520 scans ide0 and ide1.
>  kernel 2.6.24 with cs5520 is works wrong, but it can boot. cs5520 scans ide0 only.

[...]

2.6.24 contained a bug in calculating DMA base for the second port (thus
the error message) but it shouldn't affect anything (ide1 is still probed
according to dmesg, please let me know if there are some devices on ide1
that are not getting detected).

Thanks,
Bart
