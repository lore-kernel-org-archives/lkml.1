Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbZJQRHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbZJQRHW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 13:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbZJQRHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 13:07:21 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:52627 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZJQRHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 13:07:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=THGfTV3a0/4FFehBv1wQ7yDvyEvo2r0wcIypxsBqKM1TKAC0Oro5u/zxijp+XLHQ4X
         DYgwUfzeBP6539/kKoJLtdHAiHFnlCyYKHIt0anByhEXKosndUwVzxhFhijPbeVdTjgS
         Cwznsa77DMuVx7tD4x+T2PiVTi+J/SPcu1yOw=
Date: Sat, 17 Oct 2009 19:07:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Jean Delvare <khali@linux-fr.org>,
       Rodolfo Giometti <giometti@enneenne.com>,
       "Michele De Candia (VT)" <michele.decandia@valueteam.com>,
       Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH V2] ALS: TSL2550 driver move from i2c/chips
Message-ID: <20091017170718.GB10344@nowhere>
References: <4AD9F750.9090800@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD9F750.9090800@cam.ac.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 17, 2009 at 05:56:48PM +0100, Jonathan Cameron wrote:
> +static int tsl2550_get_id(void)
> +{
> +	int ret, val;
> +
> +idr_again:
> +	if (unlikely(idr_pre_get(&tsl2550_idr, GFP_KERNEL) == 0))
> +		return -ENOMEM;
> +	spin_lock(&tsl2550_idr_lock);
> +	ret = idr_get_new(&tsl2550_idr, NULL, &val);
> +	if (unlikely(ret == -EAGAIN))
> +		goto idr_again;



That looks like a fair chance to produce a deadlock
by reacquiring the above spinlock.

Also I never see the above lock released later from this
function or its caller.

