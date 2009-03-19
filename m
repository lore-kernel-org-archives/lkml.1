Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbZCSSLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbZCSSLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760240AbZCSSJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:09:07 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:47665 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760232AbZCSSJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:09:05 -0400
Subject: Re: [PATCH 1/2] regulator: Don't increment use_count for boot_on
 regulators
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1237232194-24113-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1237232194-24113-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 18:09:00 +0000
Message-Id: <1237486140.6781.340.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-16 at 19:36 +0000, Mark Brown wrote:
> Don't set use_count for regulators that are enabled at boot since this
> stops the supply being disabled by well-behaved consumers which do
> balanced enables and disabled. Any consumers which don't do disables
> which are not matched by enables are unable to share regulators - shared
> regulators are the common case so the API should facilitate them.
> 
> Consumers that want to disable regulators that are enabled when they
> start have two options:
> 
>  - Do a regulator_enable() prior to the disable to bring the use count
>    in sync with the hardware state; this will ensure that if the
>    regulator was enabled by another driver then this consumer will play
>    nicely with it.
>  - Use regulator_force_disable(); this explicitly bypasses any checks
>    done by the core and documents the inability of the driver to share
>    the supply.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

Applied.

Thanks

Liam

