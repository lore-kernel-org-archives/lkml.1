Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbZLTJ4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbZLTJ4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 04:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbZLTJ4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 04:56:47 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:55135 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbZLTJ4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 04:56:46 -0500
Date: Sun, 20 Dec 2009 20:56:44 +1100
From: Simon Horman <horms@verge.net.au>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: David Airlie <airlied@linux.ie>, Jesse Barnes <jesse.barnes@intel.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]Silancing a false positive: "may be used uninitialized"
Message-ID: <20091220095644.GA17838@verge.net.au>
References: <200912200903.28002.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912200903.28002.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 09:03:27AM +0200, Marin Mitov wrote:
> Hello all,
> 
> Silancing a false positive:
> warning: 'width' may be used uninitialized in this function
> drivers/gpu/drm/drm_edid.c

Is it guaranteed that the switch will always see a value covered by the
four cases it has?  If not width would be used without having been initialised.

Perhaps adding

		default:
			BUG();

would be worthwhile?

> 
> Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
> ==========================================================================
> --- a/drivers/gpu/drm/drm_edid.c	2009-12-20 07:43:57.000000000 +0200
> +++ b/drivers/gpu/drm/drm_edid.c	2009-12-20 07:45:49.000000000 +0200
> @@ -913,7 +913,7 @@
>  	const int rates[] = { 60, 85, 75, 60, 50 };
>  
>  	for (i = 0; i < 4; i++) {
> -		int width, height;
> +		int uninitialized_var(width), height;
>  		cvt = &(timing->data.other_data.data.cvt[i]);
>  
>  		height = (cvt->code[0] + ((cvt->code[1] & 0xf0) << 8) + 1) * 2;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
