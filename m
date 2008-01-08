Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbYAHNlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbYAHNlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 08:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYAHNk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 08:40:56 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:56762 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbYAHNkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 08:40:55 -0500
Message-ID: <47837D4E.70106@mev.co.uk>
Date: Tue, 08 Jan 2008 13:40:30 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Thunderbird 2.0.0.9 (X11/20071123)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: john_flowers@agilent.com
Subject: Re: PROBLEM:  fakephp hangs terminal in 2.6.22 (and 2.6.21), does
   not Hot Plug
References: <BD63C848ECB98D4582D05FFF2C79CFF2478356@cos-us-mb01.cos.agilent.com> <477D2710.1020103@mev.co.uk>
In-Reply-To: <477D2710.1020103@mev.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jan 2008 13:40:33.0004 (UTC) FILETIME=[0A833AC0:01C851FC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/08 18:18, Ian Abbott wrote:
> On 02/11/07 21:16, john_flowers@agilent.com wrote:
>> The "Fake" PCI Hot Plug module fakephp does not complete the slot 
>> shutdown and will hang a terminal.
>>
>>
>> I am attempting to use the fakephp module to shutdown and restart a 
>> PCI Express FPGA board when the FPGA is reloaded. Using 2.6.22 
>> (Ubuntu 7.10) or 2.6.21 (Fedora Core 7) I cannot get this 
>> functionality to work. Sending a '1' to the power file causes no 
>> change or debug output in dmesg and sending a '0' causes the terminal 
>> to hang. Please CC me as I am not subscribed to the mailing list.
> 
> I encountered the same problem today with a 2.6.24-rc6-git9 x86_64 SMP
> kernel when testing the hotplug sections of a driver I wrote.  The
> terminal locks up when echoing a '0' to a PCI slot's "power" file.  I
> added a few dbg calls in the fs_remove_slot function in
> pci_hotplug_core.c and it seems that the call to sysfs_remove_file to
> remove the "power" file that is being written to does not return.
> Perhaps the code is locking the same mutex twice in this situation?

Just a bit more maybe-helpful info....

1. The problem appeared in 2.6.21.  2.6.20 works.

2. When the process writing 0 to the 'power' file is hung, running 'ls
/sys/bus/pci/slots/<slotname>' shows an empty directory, i.e. the unlink
of the 'power' file is at least partially complete but the <slotname>
directory remains.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
