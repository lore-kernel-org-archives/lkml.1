Return-Path: <linux-kernel-owner+w=401wt.eu-S1761481AbYAKPxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761481AbYAKPxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 10:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759342AbYAKPw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 10:52:58 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:1885 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759137AbYAKPw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 10:52:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HYYibhdXJsk3OrbSi0/xaPlwuPQns6WFMxD6B/GQfRGv8FLR8HbHD5O4Go+Q2qipO6pBilEnpJrwAmNyA2N0swBpo+cNi7qkIgZ7xAlq8ofSi/oUdJC8SHDfxtqhroHdVKZs26sVBBNGiYVbyN1OFgjiZfB7QBpj0dDEQ/YDNAE=
Message-ID: <9e4733910801110752k57f1fd7crd5f143900fc64f0b@mail.gmail.com>
Date: Fri, 11 Jan 2008 10:52:56 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [i2c] [PATCH 0/5] Version 17, series to add device tree naming to i2c
Cc: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080111095638.775670ed@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071220044136.20091.70984.stgit@terra.home>
	 <20080111095638.775670ed@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/11/08, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Jon,
>
> On Wed, 19 Dec 2007 23:41:36 -0500, Jon Smirl wrote:
> > Since copying i2c-mpc.c to maintain support for the ppc architecture seems to be an issue; instead rework i2c-mpc.c to use CONFIG_PPC_MERGE #ifdefs to support both the ppc and powerpc architecture. When ppc is deleted in six months these #ifdefs will need to be removed.
> >
> > Another rework of the i2c for powerpc device tree patch. This version implements standard alias naming only on the powerpc platform and only for the device tree names. The old naming mechanism of i2c_client.name,driver_name is left in place and not changed for non-powerpc platforms. This patch is fully capable of dynamically loading the i2c modules. You can modprobe in the i2c-mpc driver and the i2c modules described in the device tree will be automatically loaded. Modules also work if compiled in.
> >
> > The follow on patch to module-init-tools is also needed since the i2c subsystem has never implemented dynamic loading.
> >
> > The following series implements standard linux module aliasing for i2c modules on arch=powerpc. It then converts the mpc i2c driver from being a platform driver to an open firmware one. I2C device names are picked up from the device tree. Module aliasing is used to translate from device tree names into to linux kernel names. Several i2c drivers are updated to use the new aliasing.
>
> Now that I have read all the previous versions of this patch series
> and, more importantly, all objections that were raised on the way, I
> can start reviewing the latest iteration of your patches. I'll also do
> some testing, although I have no powerpc stuff here, but at least I
> want to make sure that there are no regressions introduced by your
> patches on x86.


Various people were worried about x86. Around version 15 I altered the
patches so that they only impacted PowerPC. If they impact x86 in
current form that is a bug.

When x86 is ready for it I do think dynamic module loading should be
implemented there also.
>
> --
> Jean Delvare
>


-- 
Jon Smirl
jonsmirl@gmail.com
