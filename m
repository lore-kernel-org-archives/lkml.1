Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbXDBEJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbXDBEJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 00:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbXDBEJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 00:09:23 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:46017 "EHLO
	asav00.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbXDBEJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 00:09:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAH4eEEZKhRO4UGdsb2JhbACHO4hCAQEq
From: Dmitry Torokhov <dtor@insightbb.com>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
Date: Mon, 2 Apr 2007 00:09:25 -0400
User-Agent: KMail/1.9.3
Cc: Li Yu <raise.sail@gmail.com>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200703051532096508636@gmail.com> <200703300033.22059.dtor@insightbb.com> <Pine.LNX.4.64.0704010002280.6040@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0704010002280.6040@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704020009.26345.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 March 2007 18:49, Jiri Kosina wrote:
> 
> Hi,
> 
> in fact I am not entirely sure that the specialized drivers hooked to the 
> HID bus should be passed individual fields/usages by the generic HID 
> driver. That would imply that generic HID layer would have to parse the 
> received report using information retrieved from the report descriptor of 
> the device. But this is in some way in contrary to one of the features 
> this effort should be heading to, isn't it? We want to provide means how 
> to bypass possible errors in HID descriptor of the device (or do any other 
> possible quirky handling) - we want to be able to allow for completely 
> different interpretation of fields than the generic HID parser would do, 
> right?
> 
> So I guess the above should rather be
> 
> static void my_driver_hid_report(struct hid_device *hid, u8 *data, 
> 				 int size)
> {
>       if (special_processing_needed(data)) {
>               do_special_processing(...);
>               input_event(field->hidinput->input, XXX, YYY, ZZZ);
>               ...
>       } else
>               hid_input_report(hid, data, size);
> }
> 

Well, this of course is most flexible, however I think that for most
drivers hooking into parsed data would be much easier. That means that
we need to allow defining 2 hooks - one for raw data and another for
parsed reports and let drivers decice which one they want to use.

-- 
Dmitry
