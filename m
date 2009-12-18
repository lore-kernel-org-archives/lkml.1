Return-Path: <linux-kernel-owner+w=401wt.eu-S1751922AbZLRTfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbZLRTfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbZLRTf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:35:27 -0500
Received: from kroah.org ([198.145.64.141]:47508 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbZLRTf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:35:26 -0500
Date: Fri, 18 Dec 2009 10:41:46 -0800
From: Greg KH <greg@kroah.com>
To: Justin Madru <jdm64@gawab.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, error27@gmail.com,
       ray-lk@madrabbit.org
Subject: Re: [PATCH] staging: s5k3e2fx.c: simplify complexity by factoring
Message-ID: <20091218184146.GE2909@kroah.com>
References: <1260910330-3409-1-git-send-email-jdm64@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260910330-3409-1-git-send-email-jdm64@gawab.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 12:52:10PM -0800, Justin Madru wrote:
> the code was looping, seting s_move[i] to the following calculations
> 
> if (actual_step >= 0)
>         s_move[i] = ((((i + 1) * gain + 0x200) - (i * gain + 0x200)) / 0x400);
> else
>         s_move[i] = ((((i + 1) * gain - 0x200) - (i * gain - 0x200)) / 0x400);
> 
> but, this code redues to the expression
> 	s_move[i] = gain >> 10;
> 
> The reason for the complexity was to generate a step function with
> integer division and rounding to land on specific values. But these calculations
> can be simplified to the following code:
> 
> 	gain = ((actual_step << 10) / 5) >> 10;
> 	for (i = 0; i <= 4; i++)
> 		s_move[i] = gain;

Care to resend this with a Signed-off-by: line, and add the reviewed-by
line that was requested by Ray?

thanks,

greg k-h
