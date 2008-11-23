Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbYKWCA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbYKWCA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 21:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbYKWCAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 21:00:08 -0500
Received: from main.gmane.org ([80.91.229.2]:34772 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949AbYKWCAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 21:00:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Why does the md/raid subsystem does not remap bad sectors in
 a raid   array?
Date: Sat, 22 Nov 2008 19:44:32 -0600
Message-ID: <4928B580.5040800@shaw.ca>
References: <alpine.DEB.1.10.0811221859210.14817@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <alpine.DEB.1.10.0811221859210.14817@p34.internal.lan>
Cc: linux-raid@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> I asked before but it was kind of clobbered in the velociraptor mess:
> 
> On a colleague's box:
> 
> Aug 02, 2008 12:15.30AM(0x04:0x0023): Sector repair completed: port=7, 
> LBA=0x4A0387F5
> 
> SMART Self-test log structure revision number 0
> Warning: ATA Specification requires self-test log structure revision 
> number = 1
> Num  Test_Description    Status                  Remaining 
> LifeTime(hours)  LBA_of_first_error
> # 1  Extended offline    Completed: read failure       90%       305 
> 1241745397
> 
> Even though this disk has a bad sector:
> 198 Offline_Uncorrectable   0x0030   100   100   000    Old_age   
> Offline -       1
> 
> The controller does not drop the drive from the array when it hits an 
> error, the 3ware card "takes care of it" and the user need not worry 
> about it, whereas with md/raid every time it hits a bad sector, it 
> breaks the raid and it goes degraded, is this correct?  Will/can 
> something like what 3ware does be possible in a sw-raid based 
> configuration or is a HW raid card required?

Presumably all it's doing is writing that sector's contents back from 
the other drive(s) in the array when the read error is detected, this is 
something that software could do just as well. Drives only remap bad 
sectors when they are written over, as a read failure doesn't 
necessarily mean that the sector is entirely unreadable, but could be 
due to environmental factors such as high temperature, vibration, etc.

Just rewriting the sector seems a bit questionable though, as if a drive 
in your array is growing read errors that's not really a good thing..

> 
> Justin.
> 

