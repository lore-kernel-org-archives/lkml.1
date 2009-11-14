Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbZKNCvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbZKNCvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 21:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbZKNCu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 21:50:59 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:47165 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbZKNCu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 21:50:59 -0500
Message-ID: <4AFE1B0D.3060404@ahsoftware.de>
Date: Sat, 14 Nov 2009 03:50:53 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Problems with p55-express and sleeping usb-hds
References: <4AFDDDF6.4050907@ahsoftware.de> <200911140030.32727.oliver@neukum.org> <4AFDED47.5070606@ahsoftware.de>
In-Reply-To: <4AFDED47.5070606@ahsoftware.de>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 14.11.2009 00:35, schrieb Alexander Holler:
> Am 14.11.2009 00:30, schrieb Oliver Neukum:
>> Am Freitag, 13. November 2009 23:30:14 schrieb Alexander Holler:
>>> (And here comes the problem)
>>>
>>> Nov 13 19:47:34 krabat kernel: [ 2655.981980] usb 9-7: reset high speed
>>> USB device using ehci_hcd and address 3
>>> Nov 13 19:47:39 krabat kernel: [ 2661.120397] usb 9-7: device firmware
>>> changed
>>
>> You cut too early. This shows a failed reset but not the cause.
>
> There are no relevant messages in the log before:
>
> --------
> Nov 13 19:06:23 krabat kernel: [ 190.790549] EXT4-fs (dm-1): mounted
> filesystem with ordered data mode
> Nov 13 19:08:05 krabat ntpd[3381]: synchronized to 192.168.207.1, stratum 2
> Nov 13 19:08:05 krabat ntpd[3381]: kernel time sync status change 2001
> Nov 13 19:47:34 krabat kernel: [ 2655.981980] usb 9-7: reset high speed
> USB device using ehci_hcd and address 3
> ----------------------------------------------------

it might be that my assumption is totally wrong an the usb-disconnect is 
unrelated to the time the usb-drives are going to sleep. What I have 
done inbetween that mount and the disconnect was a rsync -c -n (dry-run) 
between two of those usb-discs (I'm using them for backups). Both drives 
are containing the same files, some large (up to 5-10 gb) and small 
files. Looking at the leds of those usb-drives I just assumed the 
problem happens when one of those was inactive for some time (because 
rsync computes the hash of one of the large files on the other drive).
In the excerpt of the log I've posted before, I've cut out the 
disconnect of the other drive, which has happend almost at the same time 
(and with the same consequences) as the one shown. In fact I've cut out 
one line from the log (sorry for that):
---------
Nov 13 19:08:05 krabat ntpd[3381]: kernel time sync status change 2001
Nov 13 19:47:34 krabat kernel: [ 2655.981980] usb 9-7: reset high speed 
USB device using ehci_hcd and address 3
Nov 13 19:47:35 krabat kernel: [ 2656.233278] usb 9-1: reset high speed 
USB device using ehci_hcd and address 4
Nov 13 19:47:39 krabat kernel: [ 2661.120397] usb 9-7: device firmware 
changed
Nov 13 19:47:39 krabat kernel: [ 2661.120489] usb 9-7: USB disconnect, 
address 3
---------
Afterwards the messages for the second drive where the same as for the 
one I've posted.

This is reproducible, at least through starting the rsync. I will turn 
on some debugging knobs and will see if I can see some more hints in the 
resulting logs.

Kind regards,

Alexander Holler
