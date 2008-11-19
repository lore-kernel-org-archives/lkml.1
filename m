Return-Path: <linux-kernel-owner+w=401wt.eu-S1753683AbYKSQhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbYKSQhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 11:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYKSQhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 11:37:11 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:10673 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbYKSQhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 11:37:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dNw4vsT8ujBYJfgNcpxXejRp2/ICzX3fwtm8PWIlP/DQcB2YYFTdS8d8UKzPWzu+Th
         G0nktJELHNBQM2S1dsI/55vbHt4nOJ59jgPA1bHEZ3t4LfRth33+wTC4zIHC9hN9PdXt
         XYnEk9h5g8ZcSvosSnAXTGTqefAJOq3+sJJBc=
Date: Wed, 19 Nov 2008 11:37:03 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
	protocol
Message-ID: <20081119113508.ZZRA012@mailhub.coreip.homeip.net>
References: <49142351.9080805@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49142351.9080805@euromail.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Fri, Nov 07, 2008 at 12:15:29PM +0100, Henrik Rydberg wrote:
> In order to utilize the full power of the new multi-touch devices, a
> way to report detailed finger data to user space is needed. This patch
> adds a multi-touch (MT) protocol which allows drivers to report details
> for an arbitrary number of fingers.
> 
> BTN_MT_REPORT_PACKET
> 
> The driver presses this button to indicate the start of a packet of
> finger data. The button is released after the whole packet has been
> reported.
> 
> BTN_MT_REPORT_FINGER
> 
> The driver presses this button to indicate the start of a new
> finger. The button is released when the finger has been reported.
> 
> In order to stay compatible with existing applications, the data
> reported in a finger packet must not be recognized as single-touch
> events. Therefore, a specific set of ABS_MT events is used instead.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  include/linux/input.h |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/input.h b/include/linux/input.h
> index b86fb55..c82dd42 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -590,6 +590,9 @@ struct input_absinfo {
>  #define KEY_NUMERIC_STAR	0x20a
>  #define KEY_NUMERIC_POUND	0x20b
> 
> +#define BTN_MT_REPORT_PACKET	0x210	/* report multitouch packet data */
> +#define BTN_MT_REPORT_FINGER	0x211	/* report multitouch finger data */
> +
>  /* We avoid low common keys in module aliases so they don't get huge. */
>  #define KEY_MIN_INTERESTING	KEY_MUTE
>  #define KEY_MAX			0x2ff
> @@ -642,6 +645,15 @@ struct input_absinfo {
>  #define ABS_TOOL_WIDTH		0x1c
>  #define ABS_VOLUME		0x20
>  #define ABS_MISC		0x28
> +#define ABS_MT_TOUCH		0x30	/* Diameter of touching circle */
> +#define ABS_MT_TOUCH_MAJOR	0x30	/* Major axis of touching ellipse */
> +#define ABS_MT_TOUCH_MINOR	0x31	/* Minor axis of touching ellipse */
> +#define ABS_MT_WIDTH		0x32	/* Diameter of approaching circle */
> +#define ABS_MT_WIDTH_MAJOR	0x32	/* Major axis of approaching ellipse */
> +#define ABS_MT_WIDTH_MINOR	0x33	/* Minor axis of approaching ellipse */
> +#define ABS_MT_ORIENTATION	0x34	/* Ellipse orientation */
> +#define ABS_MT_POSITION_X	0x35	/* Center X ellipse position */
> +#define ABS_MT_POSITION_Y	0x36	/* Center Y ellipse position */
>  #define ABS_MAX			0x3f
>  #define ABS_CNT			(ABS_MAX+1)
> 

Sorry for the long silence. I don't think utilizing button events for
this is a good idea. I'd rather just start reporting extended touch
events for a finger and signal end of sub-packet with something like
EV_SYN/SYN_MT_REPORT.

-- 
Dmitry
