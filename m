Return-Path: <linux-kernel-owner+w=401wt.eu-S1752256AbZG1FUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbZG1FUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 01:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZG1FUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 01:20:38 -0400
Received: from mail.farrellit.net ([66.191.143.114]:51627 "EHLO spore.ath.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZG1FUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 01:20:37 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jul 2009 01:20:37 EDT
Date: Tue, 28 Jul 2009 00:12:38 -0500
From: Dan Farrell <dan@spore.ath.cx>
To: linux-kernel@vger.kernel.org
Subject: Re: Rtl8187se & 2.6.30.3 - almost, but no wpa
Message-ID: <20090728001238.597a670e@pascal.spore.ath.cx>
In-Reply-To: <609821868-1248721321-cardhu_decombobulator_blackberry.rim.net-1499766221-@bxe1208.bisx.prod.on.blackberry>
References: <609821868-1248721321-cardhu_decombobulator_blackberry.rim.net-1499766221-@bxe1208.bisx.prod.on.blackberry>
Organization: Spore, Ltd.
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009 19:02:02 +0000
"Dan Farrell" <Dan@spore.ath.cx> wrote:

> I write to report limited success with the realtek rtl8187se wireless
> b/g network card driver in 2.6.30.3 staging.  The driver works
> AFAICT with open networks. The driver does not appear to work yet
> with WPA.  I will follow with bits from dmesg if I can figure out what
> seems relevant.  

I have not seen any issues in dmesg that appear relevant; but have
pulled from verbose debug output of wpa_supplicant the following lines:

WPA: IE in 3/4 msg does not match with IE in Beacon/ProbeResp
(src=00:13:46:5f:f3:c4) WPA: WPA IE in Beacon/ProbeResp -
hexdump(len=28): dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04
00 50 f2 02 01 00 00 50 f2 02 WPA: WPA IE in 3/4 msg - hexdump(len=28):
dd 1a 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04 00 50 f2 02 01 00
00 50 f2 02 WPA: RSN IE in Beacon/ProbeResp - hexdump(len=26): 30 18 01
00 00 0f ac 02 02 00 00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 00 00
WPA: RSN IE in 3/4 msg - hexdump(len=26): 30 18 01 00 00 0f ac 02 02 00
00 0f ac 04 00 0f ac 02 01 00 00 0f ac 02 0c 00
wpa_driver_wext_disassociate

note that RSN IE in Beacon/ProbeResp does not match WPA: RSN IE in 3/4
msg.  in the second to last byte, the former shows 00 and the later
shows 0c.  

Digging into source code...

-- dan farrell
