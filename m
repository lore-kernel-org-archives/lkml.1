Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbYIAN5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbYIAN5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 09:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYIAN5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 09:57:23 -0400
Received: from smtp-out-3.talktalk.net ([62.24.128.233]:44419 "EHLO
	smtp.talktalk.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750871AbYIAN5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:57:22 -0400
X-Greylist: delayed 625 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Sep 2008 09:57:22 EDT
X-Path: TTSMTP
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAHGPu0hOkbYa/2dsb2JhbACzGoFp
From: Alan Horstmann <gineera@aspect135.co.uk>
To: Bryan Wu <cooloney@kernel.org>, Cliff Cai <cliff.cai@analog.com>,
       alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [PATCH 3/4] ASOC: WM8731 codec: add SPI support as well as I2C
Date: Mon, 1 Sep 2008 14:52:08 +0100
User-Agent: KMail/1.5.4
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org> <1219829968-6431-4-git-send-email-cooloney@kernel.org>
In-Reply-To: <1219829968-6431-4-git-send-email-cooloney@kernel.org>
Cc: liam.girdwood@wolfsonmicro.com, broonie@opensource.wolfsonmicro.com,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809011452.08070.gineera@aspect135.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have just started trying this out as an alternative to i2c, and picked out 
the following:

On Wednesday 27 August 2008 10:39, Bryan Wu wrote:
> -#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
> +#if defined (CONFIG_I2C) || defined (CONFIG_I2C_MODULE) && !defined
> (CONFIG_SND_SOC_WM8731_SPI)

I think this needs extra brackets round the ||'s before the && thus:

> +#if (defined (CONFIG_I2C) || defined (CONFIG_I2C_MODULE)) && !defined
> (CONFIG_SND_SOC_WM8731_SPI)

in order to force use of SPI when (CONFIG_SND_SOC_WM8731_SPI) and (CONFIG_I2C) 
are both defined.  Or have we misunderstood the intention?  This is in 2 
other places also in the patch.

Alan

