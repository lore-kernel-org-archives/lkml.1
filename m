Return-Path: <linux-kernel-owner+w=401wt.eu-S1765470AbXLTP4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765470AbXLTP4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbXLTP4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:56:44 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:30768 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbXLTP4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:56:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CtItnnMe8GiQbbTUGtNHaTntJg87dPq+iM2fCUz0qX+tvGR9iMZj7bOZuRU49R8iv71dn3elz0EYQJmC9dgnmSFjyOPoG35hh6Wv9P4FvZHFarEk1CG384wz4GQOu3zxi4pB0c31c3zEQXNXfih1hy4ezWB7aBn3eOY/OPkkB1k=
Message-ID: <9e4733910712200756s40fd5d1ax8f2ca2b903befed3@mail.gmail.com>
Date: Thu, 20 Dec 2007 10:56:42 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Olof Johansson" <olof@lixom.net>
Subject: Re: [PATCH 4/5] Convert PowerPC MPC i2c to of_platform_driver from platform_driver
In-Reply-To: <20071220051618.GB29058@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071220044136.20091.70984.stgit@terra.home>
	 <20071220044144.20091.35917.stgit@terra.home>
	 <20071220051618.GB29058@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/07, David Gibson <david@gibson.dropbear.id.au> wrote:
> On Wed, Dec 19, 2007 at 11:41:44PM -0500, Jon Smirl wrote:
> > Convert MPC i2c driver from being a platform_driver to an open
> > firmware version. Error returns were improved. Routine names were
> > changed from fsl_ to mpc_ to make them match the file name.
>
> In discussions BenH and I have had, we've actually concluded that
> moving this from platform drivers to of_platform drives is not
> actually a good idea.
>
> In fact we're planning to move away from of_platform devices and
> drivers and instead develop a framework for instantiating platform
> devices or i2c devices or whatever devices from the device tree nodes.

I have to work with what is in the kernel tree so this patch is based
the current kernel. A lot of time and testing has going into all the
revisions of this patch. It has been posted in various forms for the
last month and a half.

As for platform vs of_platform, IMHO of_platform should have been
derived from platform instead of being an unrelated structure. In the
current scheme of unrelated structures it makes more sense to use one
or the other and not mix them. I am in agreement with Olof that if and
when a new scheme is adopted the drivers should be converted then.

In my local builds I have disabled platform and use only of_platform.
An of_platform only system works fine and is capable of instantiating
everything from the device tree as this patch illustrates. Once this
patch goes in I'll post another series that shows how I went
of_platform only on mpc5200.

Everyone seems to be focusing on a small piece of driver
initialization code and ignoring the much more complicated part which
implements dynamic i2c driver loading. It's the complicated part of
the code that needs review.

Ben, I know we talked about not putting the alias names into their own
namespace. But the i2c people don't want to move onto the standard
kernel aliasing scheme for other platforms and asked for #ifdef
powerpc. In version 15 I removed the cross platform support and made
everything powerpc specific. .

-- 
Jon Smirl
jonsmirl@gmail.com
