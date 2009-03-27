Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbZC0Erz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbZC0Erz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 00:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbZC0Erp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 00:47:45 -0400
Received: from [216.23.247.74] ([216.23.247.74]:51326 "EHLO
	cardinal.lizella.net" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZC0Ero (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 00:47:44 -0400
X-Greylist: delayed 660 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Mar 2009 00:47:44 EDT
To: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org
Subject: Re: Resume after hibernation regression in 2.6.29
In-Reply-To: <ck504-4x8-13@gated-at.bofh.it>
References: <ck4dD-3ce-35@gated-at.bofh.it> <ck4dD-3ce-33@gated-at.bofh.it>
 <ck504-4x8-13@gated-at.bofh.it>
Reply-To: rw@rlworkman.net
Date: Fri, 27 Mar 2009 04:35:46 +0000
User-Agent: slrn/0.9.9p1 (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090327043546.EB310B9@cardinal.lizella.net>
From: rworkman@cardinal.lizella.net (Robby Workman)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In linux.kernel, you wrote:
> On Thursday 26 March 2009 20:18:40 Pavel Machek wrote:
>> On Thu 2009-03-26 19:20:32, Tvrtko A. Ursulin wrote:
>> > Hi guys,
>> > I have been running custom compiled 2.6.28.7 in OpenSUSE 11.1 and using
>> > hiberation/resume daily as configured by the distro. Yesterday I upgraded
>> > to 2.6.29 (make oldconfig from 2.6.28.7, attached) and after resume
>> > networking (at least) does not work. Reboot at this point takes very long
>> > because of timeouts on CIFS and whatelse.
>> >
>> > Below is how /var/log/messagess looks for one cycle
>> > (hibernate-resume-reboot) and I am also attaching kernel config and
>> > /var/log/pm-suspend.log.
>> >
>> > You will probably notice evil nvidia.ko in there but don't panic, it all
>> > happens without it as well. Tested from runlevel 3 and by running
>> > pm-hibernate. After resume from that NIC LEDs were off. I
>> > tried /etc/init.d/network restart but that hung so I ^C and tried rmmod
>> > forcedeth && modprobe forcedeth && ifup eth0 and after some time network
>> > went live again. Haven't had time to test further though, so this is all
>> > pretty rough.
>>
>> Ok, can you try to rmmod forcedeth before hibernation, then insmod it
>> after resume?
>
> Sure, after insmod and /etc/init.d/network start following resume network was 
> fine. Guess I could kludge that sequence into pm scripts somehow but would 
> rather avoid that since it slows down the cycle and would make scripts 
> non-stock.


No need to modify the system pm scripts; it has support for this sort
of thing built-in.  Create /etc/pm/config.d/defaults with this line:
  SUSPEND_MODULES="forcedeth"

Obviously this is just a workaround until a real fix goes into the
kernel, but it should do what you need for now.

-RW
