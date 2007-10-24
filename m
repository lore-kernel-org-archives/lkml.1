Return-Path: <linux-kernel-owner+w=401wt.eu-S1760811AbXJXWEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760811AbXJXWEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbXJXWET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:04:19 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:55898 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341AbXJXWER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:04:17 -0400
Date: Thu, 25 Oct 2007 00:04:14 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com
Subject: Changing the number of keys supported by the input subsystem
Message-ID: <20071024220414.GC10219@hardeman.nu>
Mail-Followup-To: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the IR input handling of drivers/media/dvb/ttpci/budget-ci.c 
requires a rc5_device module option which specifies the rc5 device code 
to listen to (or as an alternative, all devices). This means, among 
other things, that multiple remotes can't be used with different 
keymaps.

My idea was to drop the module parameter and allow all rc5 device and 
command combinations to be mapped using one keyboard map.

rc5 device codes are 5 bits, command codes are 6 bits, giving a total of 
2048 possible keycodes.

However, the input subsystem is currently limited to 512 entries. So my 
question is whether it would be possible to extend that and/or make the 
size of the keymap (the keybit member of struct input_dev) dynamic?

-- 
David Härdeman
