Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab0CIBH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:07:27 -0500
Received: from LION.seas.upenn.edu ([158.130.12.194]:34323 "EHLO
	lion.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab0CIBHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:07:24 -0500
Message-ID: <4B959F3C.3020701@seas.upenn.edu>
Date: Mon, 08 Mar 2010 20:07:08 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100222 Thunderbird/3.0.1
MIME-Version: 1.0
To: mickib1@gmail.com
CC: jkosina@suse.cz, chatty@enac.fr, peterhuewe@gmx.de, micki@n-trig.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       rafi@seas.upenn.edu
Subject: Re: [PATCH 2/7] HID: N-trig MTM Driver fix and cleanup patch 2
References: <1268082827-2680-1-git-send-email-micki@n-trig.com> <1268082827-2680-2-git-send-email-micki@n-trig.com>
In-Reply-To: <1268082827-2680-2-git-send-email-micki@n-trig.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -		case HID_DG_CONTACTID: /* Not trustworthy, squelch for now */

I squelched contact id because they don't actually track fingers, rather 
contacts are reported spatially (seems to be from the bottom to top) 
making this value useless for tracking (after all the user space tools 
can count contacts since the start of the group).

See the "Finger Tracking" section in
	Documentation/input/multi-touch-protocol.txt
When tracking id is incorrect its better to just leave it out.

> +		case HID_DG_INVERT: /* value is always 0 */
> +		case HID_DG_ERASER: /* value is always 0 */
> +		case HID_DG_CONTACTID: /* value is useless */
> +		case HID_DG_BARRELSWITCH:  /* doubtful */

Stephane put these here erroneously.  He was working with a firmware 
that didn't support the stylus at all when he made those observations. 
These events are useful and should not be squelched.

> +		case HID_DG_CONTACTCOUNT:

See the rdesc for the device.
"Digitizers.ContactCount ---> Sync.Report"

As the last event sent by a mt group, that is already mapped to 
input_sync().  If you don't squelch it, you don't need to implicitly add 
the sync.

>   		case HID_DG_HEIGHT:
>   			hid_map_usage(hi, usage, bit, max,
>   					EV_ABS, ABS_MT_TOUCH_MINOR);
> -			input_set_abs_params(hi->input, ABS_MT_ORIENTATION,
> -					0, 1, 0, 0);

Stephane added the orientation to height, I can't comment about the 
wisdom of pulling it.

Rafi
