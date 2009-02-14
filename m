Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbZBNW0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbZBNW0W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbZBNW0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:26:14 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:14861 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbZBNW0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:26:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mKvYhzzuu7LMgwx3KgFjQBiKY7a/32M1H81e03yc9kvv9+GET78KcLYGFXHxbtnPPj
         F7xy+CVwKl+tR0Qvmie+Gy1feY43Wo+/a1N4Ssz3MpJi8eVhTnMvUq/kqHANEL62ikD2
         gCEdRxkCsna8qGGZcVnG82MF5mdFtNGtm5pSE=
Date: Sat, 14 Feb 2009 14:25:56 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rlove@rlove.org, Jean Delvare <khali@linux-fr.org>, protasnb@gmail.com,
       Michael Ruoss <miruoss@student.ethz.ch>,
       Tim Gardner <tim.gardner@canonical.com>,
       Frank Seidel <frank@f-seidel.de>
Subject: Re: [PATCH] hwmon/hdaps: Fix bug 7154 inversion of separate axis
Message-ID: <20090214142346.ZZRA012@mailhub.coreip.homeip.net>
References: <499569A9.5030202@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499569A9.5030202@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

On Fri, Feb 13, 2009 at 01:38:01PM +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> Fix for kernel.org bug #7154:hdaps inversion of
> each axis. This version is based on the work
> from Michael Ruoss <miruoss@student.ethz.ch>.
> 
>  
> -	/* if hdaps_invert is set, negate the two values */
> -	if (hdaps_invert) {
> +	/* hdaps_invert is a bitvector to negate the axes */
> +	if (hdaps_invert & 1)
>  		*x = -*x;
> +	if (hdaps_invert & 2)
>  		*y = -*y;
> -	}

You have defined HDAPS_{X|Y}_AXIS, why not use them?

>  
> -module_param_named(invert, hdaps_invert, bool, 0);
> -MODULE_PARM_DESC(invert, "invert data along each axis");
> +module_param_named(invert, hdaps_invert, int, 0);
> +MODULE_PARM_DESC(invert, "invert data along each axis. 1 invert x-axis, "
> +		 "2 invert y-axis, 3 invert both axes.");
>  

Why don't you make these 0644? I don't see why they can't be changed
"on fly".

-- 
Dmitry
