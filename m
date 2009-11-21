Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbZKUNvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbZKUNvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZKUNvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:51:41 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:36402 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbZKUNvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:51:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=pYHiCzHHg3baBP92APFo/GTNeq8roNnbADUes1fq/hTiEstXryuof1vj+fw4r4kIaW
         dZ5iJjTbkGoW22mmcKkurNywZGIw3QkPYmTTuMeZjND6hb3YigQd4SqcyjpTxEb6KueD
         nnbBoUHUGDInLh6yHJmG/gP0gfZDuXQJrGldw=
Message-ID: <4B07F068.1090801@gmail.com>
Date: Sat, 21 Nov 2009 14:51:36 +0100
From: Martin Fuzzey <mfuzzey@gmail.com>
Reply-To: mfuzzey@gmail.com
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: linux-serial@vger.kernel.org, tsbogend@alpha.franken.de
CC: linux-kernel@vger.kernel.org
Subject: Serial: sc26xx device name
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I noticed the sc26xx driver uses ttySC205 / ttySC206 for device name.

grep ttySC Documentation/devices.txt gives
          8 = /dev/ttySC0        SCI serial port (SuperH) - port 0
          9 = /dev/ttySC1        SCI serial port (SuperH) - port 1
         10 = /dev/ttySC2        SCI serial port (SuperH) - port 2
         11 = /dev/ttySC3        SCI serial port (SuperH) - port 3
         205 = /dev/ttySC0        SC26xx serial port 0
         206 = /dev/ttySC1        SC26xx serial port 1
         207 = /dev/ttySC2        SC26xx serial port 2
         208 = /dev/ttySC3        SC26xx serial port 3
          8 = /dev/cusc0        Callout device for ttySC0
          9 = /dev/cusc1        Callout device for ttySC1
         10 = /dev/cusc2        Callout device for ttySC2
         11 = /dev/cusc3        Callout device for ttySC3

Removing the line:
    sc26xx_reg.tty_driver->name_base = sc26xx_reg.minor;
makes it revert to ttySC0

So two questions:
1) Who is right (the driver or devices.txt)?
2) How are device name conflicts handled?

Cheers,

Martin

