Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbZKUP3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbZKUP3i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbZKUP3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:29:37 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:40518 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbZKUP3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:29:37 -0500
Message-ID: <4B080766.60703@simon.arlott.org.uk>
Date: Sat, 21 Nov 2009 15:29:42 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090927)
MIME-Version: 1.0
To: Duncan Sands <duncan.sands@math.u-psud.fr>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 3/8] cxacru: check device isn't being removed during sysfs
 calls
References: <4B08013B.90403@simon.arlott.org.uk> <4B080344.5030104@simon.arlott.org.uk> <4B080620.5050500@math.u-psud.fr>
In-Reply-To: <4B080620.5050500@math.u-psud.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/11/09 15:24, Duncan Sands wrote:
>> +static inline void *to_usbatm_driver_data(struct usb_interface *intf)
>> +static inline void *to_usbatm_atm_dev(struct usb_interface *intf)
> 
> why not collapse these two into one that just returns usbatm_instance,
> and have users extract the ->driver_data or ->atm_dev fields?

I didn't feel that the driver(s) should be accessing the fields from
usbatm_instance directly to get at atm_dev. Although this new atm_dev
function only has one caller, and cxacru already access atm_dev directly
in cxacru_poll_status() so I'll remove the second function and access
cxacru_data's usbatm pointer, which won't be NULL.

-- 
Simon Arlott
