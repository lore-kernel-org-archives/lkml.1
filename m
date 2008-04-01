Return-Path: <linux-kernel-owner+w=401wt.eu-S1762730AbYDAPb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762730AbYDAPb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932276AbYDAP1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:27:21 -0400
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:47861 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761898AbYDAP1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:27:19 -0400
Message-ID: <47F25430.7070303@panasas.com>
Date: Tue, 01 Apr 2008 18:26:40 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Oliver Neukum <oliver@neukum.org>, Sergey Dolgov <solkaa@gmail.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: usb-storage, error reading the last 8 sectors, regression in
 2.6.25-rc7
References: <Pine.LNX.4.44L0.0804011040260.4253-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0804011040260.4253-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Tue, 1 Apr 2008, Matthew Dharm wrote:
> 
>> On Tue, Apr 01, 2008 at 10:28:52AM -0400, Alan Stern wrote:
>>> On Tue, 1 Apr 2008, Oliver Neukum wrote:
>>>
>>>> Am Dienstag, 1. April 2008 03:58:31 schrieb Alan Stern:
>>>>> Nevertheless, it's clear that the problem has nothing to do with the 
>>>>> USB stack.  The real source of the problem lies in the device itself, 
>>>>> for reporting a bogus error when in fact nothing went wrong.  That may 
>>>>> also explain why you don't always see the problem -- sometimes the 
>>>>> device works the way it ought to.
>>>> Reminds me of the devices that can read the last sector but only if it is read
>>>> by itself. Do you reckon this device may have the "opposite" quirk?
>>> Could be something like that.
>> Didn't I see some SCSI patches go by to implement exactly this change?
>> That is, only read the last sector by itself?
> 
> You are getting the two problems mixed up.  The older problem, which
> the SCSI patche addressed, was that the device would fail when
> accessing the last sector unless the transfer was 1 sector long.
> 
> This problem is different.  When performing an 8-sector read that 
> includes the last sector, the device succeeds.  When performing a 
> 7-sector read starting from the same place (so not including the last 
> sector), the device fails.
> 
> Alan Stern
> 

It is a different problem but it explains why it used to work in previous
kernels. 8-sector been one page.

So it is related. Looks like another black list here. Is there a sysfs
way to disable the last-sector-thing for a usb device?

Boaz
