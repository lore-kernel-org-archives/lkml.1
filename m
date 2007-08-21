Return-Path: <linux-kernel-owner+w=401wt.eu-S1759858AbXHUMyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858AbXHUMyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 08:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756252AbXHUMyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 08:54:36 -0400
Received: from il.qumranet.com ([82.166.9.18]:48690 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbXHUMyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 08:54:35 -0400
Message-ID: <46CAE096.4060606@qumranet.com>
Date: Tue, 21 Aug 2007 15:54:46 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Laurent Vivier <Laurent.Vivier@bull.net>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       John Stoffel <john@stoffel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [kvm-devel] [PATCH 0/4] Virtual Machine Time Accounting
References: <46C99371.7070705@bull.net> <18121.39541.790665.686081@stoffel.org>	<46C9A7AB.1030003@bull.net> <46C9BD8F.4070807@goop.org>
In-Reply-To: <46C9BD8F.4070807@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Laurent Vivier wrote:
>   
>> functionnalities:
>>
>> - allow to measure time spent by a CPU in a virtual CPU.
>> - allow to display in /proc/state this value by CPU
>> - allow to display in /proc/<pid>/state this value by process
>> - allow KVM to use these 3 previous functionnalities
>>   
>>     
>
> So, currently time spent in a kvm guest is accumulated as qemu-kvm
> usertime, right?  Given that qemu knows when its running in qemu vs
> guest context, couldn't it provide the breakdown between user and guest
> time (ditto lguest)?
>   

qemu doesn't (and shouldn't) do accounting; that's best done by 
interrupt driven code.

The patches do account for guest time in a separate counter; guest time 
is added to both user time and the new counter.  This allows an old 
'top' to see guest time (accounted as user time), and a new 'top' to 
separate guest time and user time by performing the appropriate 
mathematical operation.


-- 
error compiling committee.c: too many arguments to function

