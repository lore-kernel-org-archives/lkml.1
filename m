Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab0CMDKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 22:10:45 -0500
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:49281 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945Ab0CMDKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 22:10:43 -0500
Message-ID: <4B9B022F.6060402@shikadi.net>
Date: Sat, 13 Mar 2010 13:10:39 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.23) Gecko/20091130 Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: usbhid: How to wait for response after submitting report
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm working on a USB HID driver, but my driver seems to be receiving bad data.
 I think it's because usbhid_submit_report is non-blocking and I'm not
correctly waiting for a response.  I'm not sure though, because none of the
existing usbhid drivers seem to work in this way.

Could someone please let me know if I'm going about this the right way?

  odin_psu->report->field[0]->value[0] = msg;
  odin_psu->report->field[0]->value[1] = 0x01;

  usbhid_submit_report(odin_psu->hdev, odin_psu->report, USB_DIR_OUT);
  usbhid_wait_io(odin_psu->hdev);

  usbhid_submit_report(odin_psu->hdev, odin_psu->report_in, USB_DIR_IN);
  usbhid_wait_io(odin_psu->hdev);

Many thanks,
Adam.

(Please CC)
