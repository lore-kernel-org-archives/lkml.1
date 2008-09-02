Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbYIBUPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbYIBUPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 16:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYIBUPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 16:15:36 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:59422 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbYIBUPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 16:15:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bpexaCy/fYaKtLCbiIrYLT2tH47oJnIDR/RkjvZx10g4qpL0YsQoJFpEx+qCAp3Uh6
         4QTTjtREUnlZHYx0G71GhC+2lHzLb8L3nDCdh4UHXpSZD/afPFj0W8F7XHFt62skJLiv
         UjeN++hvlHHbE73LZOmjFP4mWw90vYMJHlies=
Date: Tue, 2 Sep 2008 16:15:29 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: akpm@osdl.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcm5974-0.62: Compatibility mode reverted, BTN_TOUCH
	event added
Message-ID: <20080902161432.ZZRA012@mailhub.coreip.homeip.net>
References: <48BD9CA4.7080805@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BD9CA4.7080805@euromail.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 10:05:56PM +0200, Henrik Rydberg wrote:
> @@ -296,6 +297,7 @@ static int report_tp_state(struct bcm5974 *dev, int size)
> 
>  	input_report_abs(input, ABS_PRESSURE, int2bound(&c->p, p));
> 
> +	input_report_key(input, BTN_TOUCH, p > 0);

Just relying on p will probably make it too sensitive, have you tried
adding hysteresis, like synaptics driver does?

-- 
Dmitry
