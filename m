Return-Path: <linux-kernel-owner+w=401wt.eu-S1762108AbYBGWHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762108AbYBGWHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbYBGWHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:07:32 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:50799 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbYBGWHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:07:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=vm5coHVRkW36CBI5wUzcetgNfhT3mjEciNlV5Ls2v35sPYf8GzLVxr7PaJDGxWxH+YbtGFbKkpNTboQgpo38jUmV2s/yxj3E3+qBy7/puJCRuk+bJpfqKfaD5Uc3wzCBB/HIIKQne3qanXpmGA05pGy7XTYHO2PRbY0pVUt+4UU=
Date: Thu, 7 Feb 2008 17:07:23 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Graeme Gregory <gg@opensource.wolfsonmicro.com>,
       Mike Arthur <mike.arthur@wolfsonmicro.com>,
       Stanley Cai <stanley.cai@intel.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Marc Kleine-Budde <mkl@pengutronix.de>, Ian Molton <spyro@f2s.com>,
       Vincent Sanders <vince@kyllikki.org>,
       Andrew Zabolotny <zap@homelink.ru>
Subject: Re: [PATCH 1/6] Core driver for WM97xx touchscreens
Message-ID: <20080207170112.ZZRA012@mailhub.coreip.homeip.net>
References: <20080126151820.GA13899@sirena.org.uk> <1201368516-3513-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201368516-3513-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sat, Jan 26, 2008 at 05:28:31PM +0000, Mark Brown wrote:
> +
> +	/* register our battery device */
> +	wm->battery_dev = platform_device_alloc("wm97xx-battery", 0);
> +	if (!wm->battery_dev)
> +		goto batt_err;
...
> + batt_err:
> +	input_unregister_device(wm->input_dev);
> +	kfree(wm);
> +	return ret;
> +}

The probe error handling is not quite correct. When we reach the fragment
above ret variable is 0 so if platfrom_device_alloc() fails we will return
0 and the device will be considered bound but in half-dead state. Please
make sure that proper error is returned in all cases. Also please do not
mix out of line and in-line error unwinding (input_free_device() should
be called in the error path and if you are concerned about double-free
after input_unregister_device() just set wm->input_dev to NULL there).

Thanks.

-- 
Dmitry
