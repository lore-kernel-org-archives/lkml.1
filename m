Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab0CISvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:51:42 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:65483 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab0CISvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:51:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=a273qTIYOi++7dE5exTESfi/AZ50eKWx7sInWHTKVsXZONjf3kQLXzLpR7r39LG02A
         fcJwhSSOkouzX/kYAZX5HNFJYCKYo1cU6i5TqZy9nGfNRIJkOQifeTORhyCU3y8CqFGE
         OVdq/bGSbWkFDE3V+wQ52qEpSejVKhXYYrCGs=
Date: Tue, 9 Mar 2010 10:51:30 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: mickib1@gmail.com
Cc: jkosina@suse.cz, rafi@seas.upenn.edu, chatty@enac.fr, peterhuewe@gmx.de,
       micki@n-trig.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] HID: N-trig MTM Driver fix And cleanup patch 7
Message-ID: <20100309185130.GF19814@core.coreip.homeip.net>
References: <micki@n-trig.com>
 <1268083024-3029-1-git-send-email-micki@n-trig.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268083024-3029-1-git-send-email-micki@n-trig.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 11:17:04PM +0200, mickib1@gmail.com wrote:
> +				case REPORT_GENERIC2:
> +					if ((X_CORD_VAL == nd->x_cord) && (Y_CORD_VAL == nd->y_cord) &&
> +					    (DX_CORD_VAL == nd->dx) && (DY_CORD_VAL == nd->dy) &&
> +					    (GENERIC_BYTE_VAL == value)) {
> +						if (MAX_FINGERS_SUPPORT == nd->fake_fingers--) {
> +							input_report_abs(input, ABS_MT_TOOL_TYPE, MT_TOOL_FINGER);
> +							input_report_abs(input, ABS_MT_TRACKING_ID, END_OF_REPORT);
> +							input_event(input, EV_MSC, MSC_SCAN, nd->frame_index);

EV_MSC/MSC_SCAN is to be used to communicate scancodes or their
equivalents for the corresponsing KEV_KEY/KEY_xxx to userspace.

> +							input_sync(input);
> +							ntrig_dbg("Session Sync Frame %x\n", nd->frame_index);
> +						} else
> +							ntrig_dbg("Fake Finger %x\n", nd->frame_index);
> +					} else {
> +						input_report_abs(input, ABS_MT_TOOL_TYPE, MT_TOOL_FINGER);
> +						input_report_abs(input, ABS_MT_TRACKING_ID, nd->finger_id);
> +						input_report_abs(input, ABS_MT_POSITION_X, nd->x_cord);
> +						input_report_abs(input, ABS_MT_POSITION_Y, nd->y_cord);
> +						input_report_abs(input, ABS_MT_TOUCH_MAJOR, nd->dx);
> +						input_report_abs(input, ABS_MT_TOUCH_MINOR, nd->dy);
> +						input_event(input, EV_MSC, MSC_PULSELED, nd->generic_byte);

No, you are not pulsing the led here. Please do not overload the events
with your application-specific usage.

New events might be allocated, but the need for them must be articulated
on a purely technical basis.

Thanks.

-- 
Dmitry
