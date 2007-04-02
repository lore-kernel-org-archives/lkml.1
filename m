Return-Path: <linux-kernel-owner+w=401wt.eu-S965345AbXDBJon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965345AbXDBJon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 05:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965322AbXDBJom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 05:44:42 -0400
Received: from styx.suse.cz ([82.119.242.94]:52051 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965337AbXDBJol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 05:44:41 -0400
Date: Mon, 2 Apr 2007 11:37:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Li Yu <raise.sail@gmail.com>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Marquardt <marquardt@codemercs.com>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
In-Reply-To: <200704020009.26345.dtor@insightbb.com>
Message-ID: <Pine.LNX.4.64.0704021134250.3808@jikos.suse.cz>
References: <200703051532096508636@gmail.com> <200703300033.22059.dtor@insightbb.com>
 <Pine.LNX.4.64.0704010002280.6040@jikos.suse.cz> <200704020009.26345.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, Dmitry Torokhov wrote:

> > static void my_driver_hid_report(struct hid_device *hid, u8 *data, 
> > 				 int size)
> > {
> >       if (special_processing_needed(data)) {
> >               do_special_processing(...);
> >               input_event(field->hidinput->input, XXX, YYY, ZZZ);
> >               ...
> >       } else
> >               hid_input_report(hid, data, size);
> > }
> > 
> Well, this of course is most flexible, however I think that for most
> drivers hooking into parsed data would be much easier. That means that
> we need to allow defining 2 hooks - one for raw data and another for
> parsed reports and let drivers decice which one they want to use.

I agree. I am aware of devices for which just inspecting the parsed data 
would be OK (some keyboards with usage mappings which are not defined by 
HUT, for example), but also of devices which require special handling on 
the report level - Robert Marquardt pointed me in a private mail to a few 
devices which are broken par-excellence, and for which handling on report 
level would be convenient.

Also, handling on report level would be nice to have so that we could hook 
a hidraw driver to it.

Li, would this be OK by you?

Thanks,

-- 
Jiri Kosina
