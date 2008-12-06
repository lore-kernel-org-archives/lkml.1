Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbYLFXBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbYLFXBo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 18:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYLFXBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 18:01:35 -0500
Received: from mail.gmx.net ([213.165.64.20]:37324 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753164AbYLFXBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 18:01:34 -0500
X-Authenticated: #527675
X-Provags-ID: V01U2FsdGVkX1+EbRxn5kSEXdkmU+A79hx7ql/l1EQhSM8GqJ3IpB
	7OTa2AHZhWWEZg
Message-ID: <493B0445.9090801@gmx.de>
Date: Sun, 07 Dec 2008 00:01:25 +0100
From: Reinhard Nissl <rnissl@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.8.1.17) Gecko/20080922 SUSE/2.0.0.17-0.1 Thunderbird/2.0.0.17 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: kewei@marvell.com
Subject: mvsas determines most often an incorrect phy addr of 0 while attaching
 phy to port (Was: ERROR: Unidentified device type 0)
References: <4939ABA5.4090402@gmx.de>
In-Reply-To: <4939ABA5.4090402@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've meanwhile investigated this issue a little bit further and
changed the subject accordingly.

Reinhard Nissl schrieb:

> I've got the ASUS P6T WS Professional mainboard including Marvell
> 88SE6320 SAS controller and attached a single Seagate 10k6 SAS
> harddrive to the first SAS port.
> 
> Installation of openSUSE 11.1rc1 went well but after rebooting,
> the harddrive doesn't get found. When the initrd script loads the
> mvsas module, the following output appears on screen:
> 
> sas: phy-10:1 added to port-10:0, phy_mask:0x2 (             0)
> ERROR: Unidentified device type 0
> 
> I first tried to install openSUSE 11.0 but the installer didn't
> find the harddrive. If I recall correctly, it was for the same
> reason as it is now when trying to boot the 11.1rc1 system.

This was not completely correct. I forgot that the 11.0 installer
saw the drive at least once. And my investigations today showed
that the 11.1rc1 installer / rescue system can run into the same
error. But most often they see the drive (sometimes only after a
power cycle) while initrd didn't succeed at all (looks like a
timing issue).

> So I think, there exists already a fix for this issue, as the
> 11.1rc1 installer sees the drive, which is still missing in the
> initrd environment.
> 
> I really would like to help solving this issue, but I need a
> pointer where and how to start digging. I've started a openSUSE
> bug (https://bugzilla.novell.com/show_bug.cgi?id=450302, Bug
> 450302 - mvsas doesn't find SAS drive anymore after installation)
> almost a week ago but didn't get much help there.

Some more findings:
After the rescue system booted successfully and detected the
drive, I tried to unload mvsas. modprobe -r mvsas didn't succeed
as the module was still in use, but lsmod didn't report any user.
So I've unloaded mvsas with rmmod -f mvsas which succeeded. After
that, modprobe mvsas was loading the module successfully again
but the above error appeared. I've put up a loop with modprobe -r
/ modprobe but it never succeeded to detect the drive anymore.

My plans for the next days are to attach a SATA drive to one of
the south bridge SATA ports, install an openSUSE system there
which I will use to investigate this issue further, i. e. setup a
build environment to be able to compile the module, activate (and
possibly add additional) debug output and load the module without
having to reboot.

I really hope that someone will drop me some lines to guide me in
investigating this issue. Thanks in advance.

Bye.
-- 
Dipl.-Inform. (FH) Reinhard Nissl
mailto:rnissl@gmx.de
