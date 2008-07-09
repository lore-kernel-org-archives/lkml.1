Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbYGIM3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbYGIM3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 08:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbYGIM3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 08:29:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:64800 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261AbYGIM3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 08:29:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=a4nAA1jwHbNFhN/APKIyyT7eglOt2MeVRYooeq7UucoweKloDmf7SKtiq+g7DlpJfu
         cbAOk+0YeQVndAKB+xDvkjTPVcsD0hnge9tK7Jm+lnu98s0M4HRiqBCVC+A+a4EdaECH
         UviH2z92wdXKkF2oTsuGRdb+iZfHsnWE+MVx8=
Message-ID: <74d0deb30807090529q7e32a5c3lb2c33391ffd7e847@mail.gmail.com>
Date: Wed, 9 Jul 2008 14:29:32 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: ian <spyro@f2s.com>
Subject: Re: [patch 4/4] MFD: Change mfd platform device usage to wrapper platform_device
Cc: "Ben Dooks" <ben-linux@fluff.org>, Dmitry <dbaryshkov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <1215605639.3295.79.camel@wirenth>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080709104916.200210922@fluff.org>
	 <20080709104933.101610936@fluff.org>
	 <bc64b4640807090415w781507fetfe332271ad158112@mail.gmail.com>
	 <20080709112426.GN8489@trinity.fluff.org>
	 <bc64b4640807090431g5b1960edua2508337973615da@mail.gmail.com>
	 <20080709115045.GK8517@trinity.fluff.org>
	 <1215605639.3295.79.camel@wirenth>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2008 at 2:13 PM, ian <spyro@f2s.com> wrote:
> On Wed, 2008-07-09 at 12:50 +0100, Ben Dooks wrote:
>>
>> So, the enable/disable calls might be useful, however is there any
>> reason this could not be handled by the clock framework? The
>> suspend/resume entries where not used, and I belive should not be in
>> here.
>
> Hi Ben,
>
> I agree with you on wrapping the platform device, however the enable /
> disable methods must stay.

Ack on that. Also look also at the ds1wm driver. Right now it provides
its own enable/disable methods in platform data because it predates
the MFD core. It should be changed into an MFD cell driver, so
enable/disable methods in mfd_cell would be most useful for it.

> Other cores need them, and they arent only there for clock support.
>
> I've just looked at the TMIO MMC driver to refersh my memory and the
> suspend / resume hooks must stay also. TMIO MMC needs to be handled
> differently when suspending and when being disabled (loss of state when
> disabled).
>
> As yet, only tc6393 is 'in tree' but Im waiting for the core to settle
> down before I convert my other TMIO based code (again again) to the new
> core.
>
> So, in summary -
>
> ACK to your changes to wrap the device as an 'mfd_device'
> NAK to deleting the mfd_cell power management.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

regards
Philipp
