Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbXC3QNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbXC3QNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 12:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbXC3QNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 12:13:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:43747 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbXC3QNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 12:13:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pa1CyuEhXBHKWLB9tV3q/kpSBzlgsEQ89dGLjeFVsJ5PAl3iSZ5Li/svXj9cjfawXYyvPbucQ6WrfReEmqukri46LvphZr3Ud0XqEXTq9o9bB8hPOfd2xY2KbOcUBmZdqoUr9jKreI37yvMiHvxdKUdzFbRlwTmqTtP7jeNFMKU=
Message-ID: <d120d5000703300913n6c4e7d54jc6054daffe81a1f@mail.gmail.com>
Date: Fri, 30 Mar 2007 12:13:17 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Li Yu" <raise.sail@gmail.com>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
Cc: "Jiri Kosina" <jkosina@suse.cz>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, "Marcel Holtmann" <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <460CA201.7030006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703051532096508636@gmail.com>
	 <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com>
	 <460C7EB4.9080009@gmail.com> <200703300033.22059.dtor@insightbb.com>
	 <460CA201.7030006@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/07, Li Yu <raise.sail@gmail.com> wrote:
> I think I can understand your words. but I need confirm:
>
> Before specific driver register this device, the
> fundamental/standard/common(select one by your mind:) driver had already
> attach on it likely. At this case, we should detach this hid_device from
> its working driver, let this hid_device attach with our new specific
> driver. then new driver will handle all input event later, so the your
> words is same with the third choice in fact, is it right? if so, the
> actual behavior is same with former HID simple interface.
>

I was thinking that as we write customized drivers we would add them
(manually or automatically) to the HID blacklist so that generic
driver would not bind to such devices. Then, as your driver loads it
would parse reports and construct input device structure in the same
fashion that it processes the reports - if it is an "interesting"
report/usage it will handle setup itself; otherwise just call generic
setup function shared with the generic HID driver. This way there is
only one input device and there is no storm of add/remove events as we
loking for the proper driver to bind to the device.

Does this make sense?

This would not quite work for (potentially out of tree) HID drivers
brought in after compiling generic HID driver but that should be a
very rate occurance and we still can manually bind such drivers via
sysfs bind/unbind and new_id manipulations.

-- 
Dmitry
