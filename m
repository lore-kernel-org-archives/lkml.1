Return-Path: <linux-kernel-owner+w=401wt.eu-S964806AbXHJPx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806AbXHJPx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 11:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932452AbXHJPxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 11:53:17 -0400
Received: from styx.suse.cz ([82.119.242.94]:40803 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932447AbXHJPxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 11:53:16 -0400
Date: Fri, 10 Aug 2007 17:54:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Renato Golin <rengolin@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: joydev.c and saitek cyborg evo force
In-Reply-To: <Pine.LNX.4.64.0708101643360.11054@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0708101753410.11054@jikos.suse.cz>
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com> 
 <Pine.LNX.4.64.0706050008160.5177@jikos.suse.cz> 
 <d9b9d95f0706041546h4eef0b4eo2e191968be13d59a@mail.gmail.com> 
 <Pine.LNX.4.64.0706121436070.10204@jikos.suse.cz> 
 <d9b9d95f0706120608g979b89oc79dbc277d19862b@mail.gmail.com> 
 <d120d5000706120613o7a328e59v3cba37f0ced88e77@mail.gmail.com> 
 <d9b9d95f0706120631l20e6f91duaa110e72a0e955a6@mail.gmail.com> 
 <Pine.LNX.4.64.0706121715480.10204@jikos.suse.cz> 
 <d9b9d95f0706141524p3686a41cn882d8f086e4f62cc@mail.gmail.com> 
 <Pine.LNX.4.64.0706201156410.23812@jikos.suse.cz>
 <d9b9d95f0707201710g14d8a905s222c1209358f0196@mail.gmail.com>
 <Pine.LNX.4.64.0708101643360.11054@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007, Jiri Kosina wrote:

> Renato, does force feedback work properly in Linux with this device? If 
> so, that would mean that the device has logical maximum and minimum for 
> X and Y axes different in input and output, and we would need to handle 
> this properly (we currently don't).

Renato,

does the attached patch (against 2.6.23-rc2) fix the problem with axis 
ranges for you please?

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 8edbd30..97dbdb6 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -351,6 +351,12 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 	if (field->flags & HID_MAIN_ITEM_CONSTANT)
 		goto ignore;
 
+	if (field->report_type == HID_OUTPUT_REPORT &&
+			(usage->hid & HID_USAGE_PAGE) != HID_UP_LED) {
+		dbg_hid_line(" [non-LED output field ]");
+		goto ignore;
+	}
+
 	switch (usage->hid & HID_USAGE_PAGE) {
 
 		case HID_UP_UNDEFINED:

-- 
Jiri Kosina
SUSE Labs
