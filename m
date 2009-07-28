Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZG1PDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZG1PDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZG1PDC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:03:02 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:1696 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbZG1PDB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HAwY/oPa8hdGOxMxNf2TYy9uACMVetHkmuUIZQTMUgSfN4uZtBQAqg3g8vHBsZScnu
         WLP/3HhdMyVvWfXTPK0WOmPSz0vsXjpj/7/IB60VB467haz+yNKeeaYlx32eeaelWXv7
         jcMroY3qN5oToHBaL1jCxuYJbcNlvfyLAGvEI=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0907262320y3c5c3505h5d47d5c51025a536@mail.gmail.com>
References: <8bd0f97a0907262320y3c5c3505h5d47d5c51025a536@mail.gmail.com>
Date: Wed, 29 Jul 2009 00:03:00 +0900
Message-ID: <aec7e5c30907280803u5e0fe465gb703dd1926f1724c@mail.gmail.com>
Subject: Re: early platform drivers vs resource lookup by name
From: Magnus Damm <magnus.damm@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Greg KH <gregkh@suse.de>, damm@igel.co.jp, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Mon, Jul 27, 2009 at 3:20 PM, Mike Frysinger<vapier.adi@gmail.com> wrote:
> ive been toying with the new early platform driver framework and
> noticed a not-so-friendly feature wrt resource handling.  the
> platform_device_add() function will take care of making sure that
> every resource's name field is not NULL:
> int platform_device_add(struct platform_device *pdev)
> {
> ...
>        if (r->name == NULL)
>            r->name = dev_name(&pdev->dev);
> ...
>
> unfortunately, the early_platform_add_devices() function does not have
> similar code.  this leads to NULL pointer crashes if you attempt to
> use any of the "byname" resource functions (e.g.
> platform_get_resource_byname) and the resources in question arent
> fully named.
>
> is the simple fix here to add a resource loop to
> early_platform_add_devices() that makes sure all the name fields are
> non-NULL ?

I'm not aware of any available fix for this. I'm all for improving the
code as long as we don't add too many dependencies that prevents the
code from working very early on during the boot. Making it depend on
kmalloc() is for instance a bad idea. The early platform SuperH
drivers that I've hacked up do not use "byname" so this has not been
an issue for me so far

Please CC me on this address for future patches. =)

Cheers,

/ magnus
