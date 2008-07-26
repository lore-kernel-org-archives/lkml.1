Return-Path: <linux-kernel-owner+w=401wt.eu-S1751312AbYGZEzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbYGZEzk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 00:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYGZEzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 00:55:33 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:13035 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbYGZEzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 00:55:32 -0400
Message-ID: <fa686aa40807252155l4f785920qdb14d117067b30f4@mail.gmail.com>
Date: Sat, 26 Jul 2008 00:55:31 -0400
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Milton Miller" <miltonm@bga.com>
Subject: Re: [RFC,PATCH] scripts/package: add powerpc images to tarball
Cc: "Jeremy Kerr" <jk@ozlabs.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200807250108.m6P18f4B099179@sullivan.realtime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216887460.306306.238738123378.1.gpush@pingu>
	 <200807250108.m6P18f4B099179@sullivan.realtime.net>
X-Google-Sender-Auth: 09a4de8569141316
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 9:08 PM, Milton Miller <miltonm@bga.com> wrote:
>
>> Currently, tarball builds for powerpc kernels don't have any boot
>> images (other than vmlinux) present.
>>
>> Add support for powerpc builds in the buildtar script, to include
>> a few default images.
>>
>> Signed-off-by: Jeremy Kerr <jk at ozlabs.org>
>>
>> ---
>> RFC: any requests for more/less boot images?
>>
> ..
>> +             for img in zImage zImage.pseries zImage.iseries \
>> +                             dtbImage dtbImage.ps3
>
> Yes.  How about all dtbImage, zImage, cuboot, treeboot, etc
> that are newer than vmlinux?

dtbImage is not a buildable image.  Neither is cuImage, treeImage or
simpleImage.  All of those targets embed a device tree which is
specified by adding the .dts filename to the target name.

so, for example, 'make cuImage' fails.  Instead you do 'make
cuImage.lite5200b' which pulls in dts/lite5200b.dts.

Also, zImage is a 'meta' target that builds all the default image
targets (the $image-y list).  The zImage is actually just a symlink to
the first file in the list of default images.  So zImage can actually
point to any kind of kernel image depending on how the kernel is
configured.  I wonder if we should just remove the zImage file
entirely, or at least make it always linked to one particular image
type.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
