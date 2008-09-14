Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbYINElw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbYINElw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 00:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYINElm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 00:41:42 -0400
Received: from gw.goop.org ([64.81.55.164]:37628 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbYINElj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 00:41:39 -0400
Message-ID: <48CC95FD.3090407@goop.org>
Date: Sat, 13 Sep 2008 21:41:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Shem Multinymous <multinymous@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Elias Oltmanns <eo@nebensachen.de>,
       Thomas Renninger <trenn@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Laptop shock detection and harddisk protection
References: <48C7FCEE.8060404@kernel.org>	 <41840b750809110908o54a61f55w7b1b9793abf55634@mail.gmail.com>	 <48C948A6.3080404@kernel.org> <41840b750809111325t30f8ffe2sa4572d401d43dc5a@mail.gmail.com>
In-Reply-To: <41840b750809111325t30f8ffe2sa4572d401d43dc5a@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shem Multinymous wrote:
> Hi Tejun,
>
> On Thu, Sep 11, 2008 at 12:34 PM, Tejun Heo <tj@kernel.org> wrote:
>   
>> Hello, Shem Multinymous.
>>     
>>> Using the input device interface for the accelerometer (as done by
>>> tp_smapi's hdaps + latest hdapsd) greatly reduces the number of
>>> accelerometer-related timer interrupts on tickless kernels, as
>>> measured by powertop. With syscall polling you have the kernal polling
>>> the hardware at ~50Hz and then the userspace hdapsd polling the kernel
>>> at ~50Hz. When they're out of phase so you can get up to 100
>>> interrupts/sec. With an input device you're always at 50Hz. The phase
>>> difference also induces a small extra delay in the shock handling
>>> response.
>>>       
>> That reduction comes because input device supports poll and
>> sysfs_notify_event() does about the same thing.  The uesrland daemon
>> can just poll on a node and read data nodes when poll event on the
>> node triggeres.
>>     
>
> Agreed.
> There's another issue with the current sysfs interface, though: hdapsd
> needs to read (x,y,timestamp) tuples, whereas sysfs provides just x
> and y in separate attributes which cannot be read atomically together.
> We can add a sysfs file with "x y timestamp" readouts, though this is
> unusual for sysfs (and certainly incompatible with hwmon).
>   

Assuming timestamp is always updated when the x,y values change, you can do:

	do {
		ts = read_timestamp();
		x = read_x();
		y = read_y();
		ts2 = read_timestamp();
	} while(ts != ts2);






    J
