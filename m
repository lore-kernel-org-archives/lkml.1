Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681Ab0AIPBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab0AIPBk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 10:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103Ab0AIPBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 10:01:40 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:9718 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab0AIPBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 10:01:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=klFX7OFqOTcbr+MKIqm+bLhpUI8GGAcaRpX/gW/Z9R3rze2E15Azlv010GbdRtRlNH
         M3RrVaXg2CAQy6afS6uM/9C25g6ZREJ1QiTlrX8J9j8WV+QVBxIXLjNeXnrP9r89NYEk
         ls9ozLVE6Mc+wUszA3wzqdoNy+HZdtBm/NvQM=
Message-ID: <4B489B44.50101@gmail.com>
Date: Sat, 09 Jan 2010 16:05:40 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: HID: is scancode correctly reported after key status change in hidinput_hid_event()?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vi drivers/hid/hid-input.c +634 and not in hidinput_hid_event()

 	/* report the usage code as scancode if the key status has changed */
	if (usage->type == EV_KEY && !!test_bit(usage->code, input->key) != value)
 		input_event(input, EV_MSC, MSC_SCAN, usage->hid);

Only if value is 1 or 0 the input_event() can occur, but value doesn't
seem to be intended to be used as a boolean. are we really doing the
correct test here?

Roel
