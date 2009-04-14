Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbZDNCbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbZDNCbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 22:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZDNCbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 22:31:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:1967 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbZDNCbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 22:31:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=VNThlwhmlUjWjKNjzLuN8/FQeWI+l/WiJqhntugIJ1uT1g7tHeFtQX/N6OcOelBJ9u
         oKNqriiCUyub+4qGOVBKQELvxiBBGzpnb4zvxs1KfGtqU1Ar7lOX8xLSzWbo/O1WtCKl
         gmadIt7Wj0t+FRq29stHRbqnsBD1EctB+tazY=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <lkml@rtr.ca>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Input driver for Twinhan USB 6253:0100 remote control
Date: Mon, 13 Apr 2009 19:31:23 -0700
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-170.2.56.fc10.x86_64; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <20090408072935.GA27920@dtor-d630.eng.vmware.com> <49DCDEA9.2020502@rtr.ca>
In-Reply-To: <49DCDEA9.2020502@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904131931.24009.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wednesday 08 April 2009 10:28:09 Mark Lord wrote:
> Dmitry,
>
> I briefly had access to a Twinhan remote control (for Mythtv et al.)
> and cobbled something together quickly to make it work.
>
> But I really don't understand the new hid/input stuff,
> so this is undoubtedly a total abomination to your eyes. :)
>

Actually HID is Juri's baby so let's see what he says ;). From my POV
we need to update keymap to make it emit proper codes instead of Myth
specific ones, but that is a lesser issue.

> But if somebody could give *exact* and *detailed* instructions as
> to what to do to make it "fit" the new model better, then I may still
> have time (before I have to return it) to clean things up enough.
>
> I don't want to hear about 80-column limits,
> but rather how to properly integrate this into
> the newly refurbished hid stuff.
>
> Have a look.  Currently it's just this single source file,
> which has to be loaded before usbhid (not on the quirks list there yet).
>
>
>
> /*
>  *  HID driver for Twinhan remote control
>  *
>  *  Copyright (c) 2009 Mark Lord
>  *
>  * This program is free software; you can redistribute it and/or modify it
>  * under the terms of the GNU General Public License as published by the
> Free * Software Foundation; either version 2 of the License, or (at your
> option) * any later version.
>  */
>
> #include <linux/device.h>
> #include <linux/input.h>
> #include <linux/hid.h>
> #include <linux/module.h>
>
> #ifndef HID_USB_DEVICE
> #error "This driver requires a 2.6.28 (or higher) Linux kernel"
> #endif
>
> /* See /usr/include/linux/input.h for all possible KEY_* definitions */
>
> static unsigned int twinhan_keymap (unsigned int key)
> {
> 	switch (key) {
> 	case 0x04: key = KEY_RESERVED   ; break; // Teletext	()
> 	case 0x06: key = KEY_ESC        ; break; // Recall	(myth
> Escape/Cancel/Back) case 0x08: key = KEY_S          ; break; // EPG		(myth
> guide)
> 	case 0x0c: key = KEY_HOME       ; break; // Rewind	(myth commskip back)
> 	case 0x0e: key = KEY_P          ; break; // Preview	(myth playback)
> 	case 0x0f: key = KEY_F3         ; break; // RecordList	(myth DVD root
> menu) case 0x10: key = KEY_F9         ; break; // Mute	(myth mute ??)
> 	case 0x11: key = KEY_END        ; break; // Forward	(myth commskip
> forward) case 0x13: key = KEY_RESERVED   ; break; // Capture	()
> 	case 0x17: key = KEY_P          ; break; // Pause	(myth Pause)
> 	case 0x19: key = KEY_M          ; break; // Favorite	(myth Menu)
> 	case 0x1d: key = KEY_W          ; break; // FullScreen	(myth aspect ratio
> zoom) case 0x1e: key = KEY_1          ; break; // 1		(myth 1)
> 	case 0x1f: key = KEY_2          ; break; // 2		(myth 2)
> 	case 0x20: key = KEY_3          ; break; // 3		(myth 3)
> 	case 0x21: key = KEY_4          ; break; // 4		(myth 4)
> 	case 0x22: key = KEY_5          ; break; // 5		(myth 5)
> 	case 0x23: key = KEY_6          ; break; // 6		(myth 6)
> 	case 0x24: key = KEY_7          ; break; // 7		(myth 7)
> 	case 0x25: key = KEY_8          ; break; // 8		(myth 8)
> 	case 0x26: key = KEY_9          ; break; // 9		(myth 9)
> 	case 0x27: key = KEY_0          ; break; // 0		(myth 0)
> 	case 0x29: key = KEY_ESC        ; break; // Cancel	(myth
> Escape/Cancel/Back) case 0x28: key = KEY_ENTER      ; break; // Play	(myth
> Okay/Play) case 0x2b: key = KEY_RESERVED   ; break; // Tab		()
> 	case 0x3f: key = KEY_F2         ; break; // Power	(myth function key 2)
> 	case 0x4a: key = KEY_R          ; break; // Record	(myth record)
> 	case 0x4b: key = KEY_UP         ; break; // Up/CH+	(myth up)
> 	case 0x4d: key = KEY_B          ; break; // Stop	(myth adjust audio sync)
> 	case 0x4e: key = KEY_DOWN       ; break; // Down/CH-	(myth down)
> 	case 0x51: key = KEY_LEFT       ; break; // Left/VOL-	(myth left)
> 	case 0x52: key = KEY_RIGHT      ; break; // Right/VOL+	(myth right)
> 	//case 0xe0:	// excess code from Power button
> 	//case 0xe1:	// excess code from Power,Left,Right buttons
> 	//case 0xe2:	// excess code from Power button
> 	//case 0xef:	// excess code from Power button
> 	default:   key = KEY_RESERVED   ; break; // ignored
> 	}
> 	return key;
> }
>
> static int twinhan_event(struct hid_device *hdev, struct hid_field *field,
> 			 struct hid_usage *usage, __s32 value)
> {
> 	struct input_dev *input = field->hidinput->input;
> 	static unsigned int last_key = 0;
> 	unsigned int key;
> 	int ret = 0;
>
> 	if (!(hdev->claimed & HID_CLAIMED_INPUT) || !field->hidinput ||
> !usage->type) return 0;
> 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_KEYBOARD)
> 		return 0;
>
> 	if (last_key) {
> 		input_event(input, usage->type, last_key, 0);
> 		last_key = 0;
> 		ret = 1;
> 	}
> 	if (value) {
> 		unsigned int val = usage->hid & HID_USAGE;
> 		key = twinhan_keymap(val);
> 		if (key) {
> 			input_event(input, usage->type, key, 1);
> 			last_key = key;
> 		}
> 		ret = 1;
> 	}
> 	return ret;
> }
>
> static const struct hid_device_id twinhan_devices[] = {
> 	{ HID_USB_DEVICE(0x6253, 0x0100) },
> 	{ }
> };
> MODULE_DEVICE_TABLE(hid, twinhan_devices);
>
> static struct hid_driver twinhan_driver = {
> 	.name		= "twinhan",
> 	.id_table	= twinhan_devices,
> 	.event		= twinhan_event,
> };
>
> static int twinhan_init(void)
> {
> 	return hid_register_driver(&twinhan_driver);
> }
>
> static void twinhan_exit(void)
> {
> 	hid_unregister_driver(&twinhan_driver);
> }
>
> module_init(twinhan_init);
> module_exit(twinhan_exit);
> MODULE_LICENSE("GPL");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Dmitry
