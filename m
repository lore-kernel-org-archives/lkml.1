Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab0BLXBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 18:01:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:5401 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582Ab0BLXBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 18:01:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nbG6MzHWzRJ3cbqxCkq/IY4IFqJkSLl+VSEu7rHIpopDlhQddIeJjIPy9DWIEqlTr2
         8JR7kfIqpXlgthoxf3HSlV+ENR2nFmyD6iC64WUSppuzjFadzUNSSKxfVwgoxkC+sLCz
         1GTBhX61QCkrjQhPKr27mvCkKwJCJmCU3/diU=
MIME-Version: 1.0
In-Reply-To: <1265969888-16946-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1265918499-9583-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1265969888-16946-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Sat, 13 Feb 2010 01:01:07 +0200
Message-ID: <6ed0b2681002121501m32995aaekd3ce2f4fabd91050@mail.gmail.com>
Subject: Re: [PATCH] regulator: Provide optional dummy regulator for consumers
From: Grazvydas Ignotas <notasas@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Mike Rapoport <mike@compulab.co.il>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 12:18 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> In order to ease transitions with drivers are boards start using regulators
> provide an option to cause all regulator_get() calls to succeed, with a
> dummy always on regulator being supplied where one has not been configured.
> A warning is printed whenever the dummy regulator is used to aid system
> development.
>
> This regulator does not implement any regulator operations but will allow
> simple consumers which only do enable() and disable() calls to run. It
> is kept separate from the fixed voltage regulator to avoid Kconfig
> confusion on the part of users when it is extended to allow boards to
> explicitly use the dummy regulator to simplify cases where the majority
> of supplies are from fixed regulators without software control.
>
> This option is currently only effective for systems which do not specify
> full constriants. If required an override could also be provided to allow
> these systems to use the dummy regulator, though it is likely that
> unconfigured supplies on such systems will lead to error due to
> regulators being powered down more aggressively when not in use.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>

hm, tried intentionally nuking regulator setup on my board to test
dummy and drivers started failing on regulator_enable() with -1
(EPERM?). Looks like dummy doesn't have constraints defined, so not
much use of this if _enable() is failing anyway.

BTW, drivers/mmc/host/omap_hsmmc.c has quite a lot of logic related to
vcc_aux being available or not (vcc_aux is typically used to power
some MMC pins and is unused on devices with SD cards, like pandora). I
wonder if it may cause some functionality change there.
