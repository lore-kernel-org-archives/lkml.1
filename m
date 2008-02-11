Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbYBKFWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbYBKFWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 00:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbYBKFWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 00:22:07 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:34272 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbYBKFWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 00:22:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=ZYuDVKmQTp7fyQ7zHWJMyHlj/zPpsIkEbJTa230J5Qo9JNEZs5s2BOJRA6sRw0IwxwEvQ6k52HLRv122c8IOvfXOhtGpOVD+j0ECH4LGCaFrpDun8usgevGO9YejxavIwJZfZb8Mc9U1OijVCKMSdYyBne3O54v4VUx4w3wbTLs=
Message-ID: <47AFDC4D.4070400@gmail.com>
Date: Mon, 11 Feb 2008 03:25:33 -0200
From: "Carlos R. Mafra" <crmafra@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com
Subject: [2.6.25-rc1 regression] Suspend to RAM (bisected)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want to report that suspend to RAM stopped working on my Sony Vaio 
VGN-FZ240E in 2.6.25-rc1 and that I could bisect the problem down
to:

commit bc71bec91f9875ef825d12104acf3bf4ca215fa4
Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
Date:   Thu Jan 31 17:35:04 2008 -0800

    ACPI: enable MWAIT for C1 idle

    Add MWAIT idle for C1 state instead of halt, on platforms that support
    C1 state with MWAIT.

    Renames cx->space_id to something more appropriate.

    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

The problem with suspend to RAM is that right after typing (from inside X)
'echo mem > /sys/power/state' the screen becomes black and the laptop 
freezes. I have to use SysRq+b to reboot.

I tried to revert the above commit (bc71bec) on top of 2.6.25-rc1, but
the compilation fails. It turns out that I have to revert also 9a0b8415 and
9b12e18c to be able to compile without errors. 

After reverting the 3 commits mentioned above, the resulting 2.6.25-rc1 kernel
can suspend to RAM again (and I must say that it is better that 2.6.24, because
now it resumes directly into X and I don't need to use Crtl-Alt-F1 and Alt-F7 to
go back to X as I used to do before).

The laptop is a Core 2 Duo T7250 2.0 GHz, running Mandriva 2008.0 in 64-bit mode, with the
following graphics card:
VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c) (prog-if 00 [VGA])

If there is anything else I can do to help please let me know.

Carlos R. Mafra


