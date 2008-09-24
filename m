Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbYIXQE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbYIXQE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYIXQET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:04:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:28213 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbYIXQES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:04:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xBE5koKCIQLfsFlBD+5LwWnbXy1tYRNrr4lcQAAh88Q1ejRCm+xb7ZcNI3qtx3wnBK
         J08tLs/3u/+dY7zpApIl72F8vfvRp8C4xScQNrcbHniM7jRCYzLWz+5Q1DMCK6L+g2pF
         3mXm9cgjpNW0rKeHfLxEl8WjTiXnjLyU2ZYwc=
Message-ID: <48DA64FC.4020706@gmail.com>
Date: Wed, 24 Sep 2008 18:04:12 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: suspend (uhci_hcd) defunct in mmotm 2008-09-13-03-09
References: <Pine.LNX.4.44L0.0809241047500.2650-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0809241047500.2650-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2008 04:49 PM, Alan Stern wrote:
> On Wed, 24 Sep 2008, Jiri Slaby wrote:
> 
>>>> pm_op(): pci_pm_suspend+0x0/0xd0 returns -16
>>>> PM: Device 0000:00:1d.0 failed to suspend: error -16
>>>> PM: Some devices failed to suspend
>>> The reason for this error is that the root hub wasn't already 
>>> suspended.  Was there a USB device plugged into that controller?
>> No:
> 
>>> If you still run into problems, post more of the dmesg log (with 
>>> CONFIG_USB_DEBUG enabled, of course!).
>> Hm, it doesn't work. 2 dmesgs from mmotm 2008-09-10-19-39 (without usb debug)
>> [ok] and -rc6+gkh-all (with usb debug) [fail]:
>> http://decibel.fi.muni.cz/~xslaby/dmesg_fail.hcd
>> http://decibel.fi.muni.cz/~xslaby/dmesg_ok.hcd
> 
> In fact neither of those logs includes USB debugging messages.  Maybe
> you omitted a mkinitrd step.

I don't think so. I don't use neither vanilla nor initrd so this must be the
kernel. Anyway I recompiled with .config linked in and did
# dmesg >dmesg_config.hcd
# zcat /proc/config.gz >>dmesg_config.hcd
in the built kernel. The file is here:
http://decibel.fi.muni.cz/~xslaby/dmesg_config.hcd
