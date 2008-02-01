Return-Path: <linux-kernel-owner+w=401wt.eu-S1757996AbYBAT1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbYBAT1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 14:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYBAT1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 14:27:14 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:42051 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753606AbYBAT1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 14:27:13 -0500
Date: Fri, 1 Feb 2008 14:27:11 -0500
To: veerasena reddy <veerasena_b@yahoo.co.in>
Cc: "linux-kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: how to get chance for user space process even when the kernel is utilizing 100% CPU.
Message-ID: <20080201192711.GD26259@csclub.uwaterloo.ca>
References: <380904.30308.qm@web8401.mail.in.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <380904.30308.qm@web8401.mail.in.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 11:41:48PM +0530, veerasena reddy wrote:
> I have a requirement where i need to execute a user process even when the kernel is utilizing 100% of CPU time.
> 
> Actual scenario is as below:
> i have a device on my board. this device keeps generating regular (for every 2secs) messages for a user process. the user process has to poll on the device for any message is there to read and get the message from the device. once the user process reads the message it will be removed in device and uses for further/subsequent messages.
> 
> I have a test case where i need to send so much traffic through my board such that the kernel will be utilizing 100% CPU time to process this data. At this time (when CPU is 100% utilized) the user space process is not getting scheduled even after a long duration (say 10 minutes to 45 minutes). Mean time the message buffer in the device is filled up and the device halts (aka controlled crash; the device firmware has been designed like this) as there is no more memory on the device.
> 
> To avoid this scenario of device's message queue getting filled up because of the user space process not reading them, could you please anyone suggest some technique for getting my user space process scheduled even when there is very heavy traffic as described above.
> 
> In simple, i can put my requirement like this:
>     Is there any way i can get a user space process get scheduled in the above condition (kernel occupying 100% of CPU due to heavy traffic)

The simple answer is that you made a design mistake.  If the CPU can't
keep up with the data then you picked the wrong cpu for the job.

The more complex answer is that you probably really need a realtime
system where you can set guarenties on the scheduler time for a given
task, even at the expense of the kernel.

On the system I work on we had to make sure the 4 ethernet ports didn't
overload the CPU, and we actually have the ethernet driver check the
system cpu percentage over a small interval and if it goes over a
specified percentage, then the port will stop processing incoming
packets for one jiffy, giving some time for user space tasks.  It's a
bit of an ugly hack, but it sure works well.

--
Len Sorensen
