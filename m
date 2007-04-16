Return-Path: <linux-kernel-owner+w=401wt.eu-S1030599AbXDPNPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030599AbXDPNPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 09:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030603AbXDPNPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 09:15:30 -0400
Received: from styx.suse.cz ([82.119.242.94]:52721 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030599AbXDPNPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 09:15:30 -0400
Date: Mon, 16 Apr 2007 15:22:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Li Yu <raise.sail@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       =?UTF-8?B?5p2o57qi?= <yanghong@ccoss.com.cn>,
       =?iso-2022-jp?Q?=1B$B9=3F=3BV5#=1B=28J?= <hongzhiyi@ccoss.com.cn>
Subject: Re: [PATCH] hid: hid bus prototype 20070416
In-Reply-To: <46230EDE.5020300@gmail.com>
Message-ID: <alpine.LSU.0.98.0704161504280.18903@jikos.suse.cz>
References: <46230EDE.5020300@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007, Li Yu wrote:

> HID bus prototype 20070416

Hi Li,

thanks for taking care. Well, the patch is quite huge, do you think you 
could split it into separate independent parts (use quilt or something 
similar for patch management) which could be reviewed independently?

As the code changes are often quite non-trivial, layering is changed, 
lots of files are touched, etc. it would help a lot.

Notes from a quick skim through the patch:

- it seems that you accidentaly deleted the newly added quirk for
   mightymouse in the bluetooth hid code?
- what is the point behind HID_QUIRK_SKIP? Why doesn't HID_QUIRK_IGNORE
   suffice? And why is it defined in so strange way:

@@ -270,6 +271,7 @@ struct hid_item {
  #define HID_QUIRK_LOGITECH_DESCRIPTOR          0x00100000
  #define HID_QUIRK_DUPLICATE_USAGES             0x00200000
  #define HID_QUIRK_RESET_LEDS                   0x00400000
+#define HID_QUIRK_SKIP                         0x80000000

- there are bunches of some easy codingstyle issues (spaces around '=',
   etc)

But doing really thorough review is quite hard, as the patch contains lots 
of unrelated changes. I'll look at it a little bit more, but when you send 
a broken-out version with separate changes, that'd be great.

Thanks,

-- 
Jiri Kosina
