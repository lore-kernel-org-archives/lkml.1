Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZBVTpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZBVTpf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 14:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZBVTp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 14:45:27 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:58901 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbZBVTp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 14:45:26 -0500
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: isight_firmware interacts badly with suspend/resume
Date: Sun, 22 Feb 2009 19:45:21 +0000
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-excalibur; KDE/4.2.0; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200902221945.21571.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A 2.6.29-rc5 S3 suspend/resume cycle seems to break on my 2007 Macbook if I 
have isight_firmware loaded and a valid isight firmware in /lib/firmware.

Normally this module loads/unloads fine (though I've never actually used the 
webcam).

The breakage is not obvious. There's no kernel oops, and my console is 
restored, but only Alt-Fx works, no other keys work. I've had this module 
loaded during suspend/resume since it was introduced into mainline, but I've 
only had problems with it in 2.6.29 and possibly 2.6.28 (can check for sure if 
required).

At the moment I'm rmmod'ing the module before echo mem >/sys/power/state and 
then modprobe'ing it after. This fixes the cycle. At a guess this looks like 
some kind of request_firmware() race (that's the last kernel message I get on 
resume before the hang).

Does isight_firmware actually need to do anything on resume? Is the firmware 
lost for sure in S3? Anything else I can do to debug this?

-- 
Cheers,
Alistair.
