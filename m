Return-Path: <linux-kernel-owner+w=401wt.eu-S932935AbZACVLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935AbZACVLV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 16:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932395AbZACVLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 16:11:11 -0500
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:37275 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbZACVLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 16:11:09 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <495FD46E.8040208@cam.ac.uk>
Date: Sat, 03 Jan 2009 21:11:10 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com
Subject: [RFC] Regulator: Possibility of passing notifications of non alarm
 events.
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

I am in the process of writing an hwmon driver for the Sensiron SHT15 humidity
sensor.

In common (I assume) with lots of other devices, the formula for converting
the outputs of this chip to real units involves the supply voltage.
Unfortunately the chip doesn't itself have any means of measuring this.
Obviously this can be supplied via a board config if it is constant.

As I have it connected to a DA9030 pmic I can register it as a consumer
and hence query what the pmic thinks it is supplying.

Unfortunately this regulator is shared with a number of other chips and so
there is no guarantee that this voltage won't be changed (within the bounds
supported by the SHT15).  I'd like to avoid querying the regulator voltage
every time I do a conversion.

As the regulator framework already allows you to register to receive events
such as under voltage detections, it seems to me that it would also make sense
to allow registrations of handlers for events that occur during normal
operation such as voltage changes.

What do people think to adding this functionality?

Thanks

--
Jonathan Cameron
