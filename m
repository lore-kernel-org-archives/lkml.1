Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab0CILBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 06:01:24 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:60379 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab0CILBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 06:01:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rku+hoQC+SJEEUWS/qbFYUvuyiyW+erBej1Z0Cx1wWNyrwkNedDRcKcc1eo8BPS5EY
         e84QuDc6mXX9SStb3lGMGFOAbiPjniDhYLrKt1LLj+IYQVJhC8kipjmh3mnk0Gi6jT18
         G9ZbsM5TdLCUeERj6VE3IyyO+e0RP8O9f04yU=
MIME-Version: 1.0
In-Reply-To: <201003062236.09801.rjw@sisk.pl>
References: <201003062236.09801.rjw@sisk.pl>
Date: Tue, 9 Mar 2010 12:01:18 +0100
Message-ID: <68676e01003090301s5bb40d4hac1224a9658339ac@mail.gmail.com>
Subject: Re: [Q] How to tell we're using the KMS (during suspend/resume) 
	outside the graphics driver
From: Luca Tettamanti <kronos.it@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 6, 2010 at 10:36 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>
> For at least two reasons it would be beneficial for some code outisde the
> graphics driver(s) to know if the KMS are used.
>
> First, in the non-KMS (ie. UMS) case we probably wouldn't want to call
> acpi_video_resume(), because that has a potential to mess up with the GPU
> (it actually is known to do that on at least one system).
>
> Second, in the KMS case, we'd be able to skip the kernel VT switch, because
> the KMS driver uses its own framebuffer anyway.
>
> So, is there any reasonable way to check that from the outside of the graphics
> driver?  It should be general enough to cover the cases when there are two
> graphics adapters with different drivers in the system and so forth.

Inside the kernel? If you have a struct pci_dev you can get the
associated struct drm_device with pci_get_drvdata and then check the
KMS feature: drm_core_check_feature(dev, DRIVER_MODESET).
I'm note sure how to check that a device is graphic card though :|

Luca
