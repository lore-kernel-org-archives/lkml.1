Return-Path: <linux-kernel-owner+w=401wt.eu-S1759727AbYBGGYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727AbYBGGYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbYBGGSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:18:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:57597 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298AbYBGGSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:18:10 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Roel Kluin <12o3l@tiscali.nl>
Subject: Re: [PATCH][drivers/misc/thinkpad_acpi.c] duplicate test if (level & TP_EC_FAN_FULLSPEED)
Date: Thu, 7 Feb 2008 01:17:44 -0500
User-Agent: KMail/1.9.5
Cc: Roland Dreier <rdreier@cisco.com>, len.brown@intel.com,
       ibm-acpi@hmh.eng.br, ibm-acpi-devel@lists.sourceforge.net,
       linux-acpi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
References: <47A78CBB.2090401@tiscali.nl> <ada8x20gykq.fsf@cisco.com> <47A79EC8.6060700@tiscali.nl>
In-Reply-To: <47A79EC8.6060700@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802070117.45119.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

thanks,
-Len

On Monday 04 February 2008 18:24, Roel Kluin wrote:
> Roland Dreier wrote:
> >  >                 /* safety net should the EC not support AUTO
> >  >                  * or FULLSPEED mode bits and just ignore them */
> >  >                 if (level & TP_EC_FAN_FULLSPEED)
> >  >                         level |= 7;     /* safety min speed 7 */
> >  >                 else if (level & TP_EC_FAN_FULLSPEED)
> >  >                         level |= 4;     /* safety min speed 4 */
> >  > 
> >  > Note the duplicate test 'if (level & TP_EC_FAN_FULLSPEED)'. should
> >  > this be replaced by
> > 
> > Actually I suspect one of the two tests should be against TP_EC_FAN_AUTO
> > (based on the comment).
> > 
> 
> Thanks Roland, for your info
> 
> based on the comments in commit eaa7571b2d1a08873e4bdd8e6db3431df61cd9ad,
> I think this should be modified like below:
> 
> ACPI: thinkpad-acpi: add a safety net for TPEC fan control mode
> The Linux ThinkPad community is not positive that all ThinkPads that do
> HFSP EC fan control do implement full-speed and auto modes, some of the
> earlier ones supporting HFSP might not.
> 
> If the EC ignores the AUTO or FULL-SPEED bits, it will pay attention to the
> lower three bits that set the fan level. And as thinkpad-acpi was leaving
> these set to zero, it would stop(!) the fan, which is Not A Good Thing.
> So, as a safety net, we now make sure to also set the fan level part of the
> HFSP register to speed 7 for full-speed, and a minimum of speed 4 for auto
> mode.
> --
> second TP_EC_FAN_FULLSPEED should be P_EC_FAN_AUTO
> 
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
> index cf56647..3c323fe 100644
> --- a/drivers/misc/thinkpad_acpi.c
> +++ b/drivers/misc/thinkpad_acpi.c
> @@ -4138,7 +4138,7 @@ static int fan_set_level(int level)
>  		 * or FULLSPEED mode bits and just ignore them */
>  		if (level & TP_EC_FAN_FULLSPEED)
>  			level |= 7;	/* safety min speed 7 */
> -		else if (level & TP_EC_FAN_FULLSPEED)
> +		else if (level & TP_EC_FAN_AUTO)
>  			level |= 4;	/* safety min speed 4 */
>  
>  		if (!acpi_ec_write(fan_status_offset, level))
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
