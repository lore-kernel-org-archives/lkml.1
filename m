Return-Path: <linux-kernel-owner+w=401wt.eu-S932532AbYBGQ7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbYBGQ7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbYBGQ7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:59:22 -0500
Received: from mail.syneticon.net ([213.239.212.131]:55367 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbYBGQ7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:59:21 -0500
Message-ID: <47AB38E2.9050509@wpkg.org>
Date: Thu, 07 Feb 2008 17:59:14 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       Horms <horms@verge.net.au>
Subject: Re: why kexec insists on syncing with recent kernels?
References: <47AB120A.1000600@wpkg.org> <20080207163752.GD11969@redhat.com>
In-Reply-To: <20080207163752.GD11969@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal schrieb:
> On Thu, Feb 07, 2008 at 03:13:30PM +0100, Tomasz Chmielewski wrote:
>> According to kernel/kexec.c:
>>
>>  * kexec does not sync, or unmount filesystems so if you need
>>  * that to happen you need to do that yourself.
>>
>>
> 
> In latest kexec code I do see it syncing. But it does not unmount the
> filesystems. So this comment looks like partially wrong.
> 
>> I saw this was true with 2.6.18 kernel (i.e., it didn't sync), but kexec 
>> syncs with recent kernels (I checked 2.6.23.14 and 2.6.24):
>>
>> # kexec -e
>> md: stopping all md devices
>> sd 2:0:0:0: [sdb] Synchronizing SCSI cache
> 
> Which kexec-tools you are using? 

# kexec -v
kexec 1.101 released 15 February 2005


> syncing is initiated by user space so changing kernel will not have
> any effect (as long as user space is same). I think just that message
> are spitted by kernel, so probably 2.6.18 did not spit any message and
> 2.6.24 does.

Yes and no.
I just booted 2.6.24 on a diskless system (Mandriva) I normally use with 
2.6.18 kernel, did kexec -e... And it executed the kernel immediately, 
without any syncing.
On Debian, with the same 2.6.24 kernel, it does sync.

So what user space part does the syncing (and how to prevent it)?

(...)


>> The way kexec works now makes rebooting unreliable again:
>> - network interfaces are brought down,
>> - kernel tries to sync - it never will, as we're booted off network, which 
>> is down
>>
> 
> Kexec has got an option -x --no-ifdown, which will not bring the network
> down. Try that. "kexec- -e -x"

It does seem to help, thanks.

Why it has to be the last option specified?

I tried -f option before (don't call shutdown), but it didn't help.


>> Any ideas why kexec insists on syncing?
> 
> To me it makes sense. Just making sure that cache changes make to the file
> system before you boot into new kernel.
> 
> In latest kexec-tools, I do see sync() is done first and then network
> interfaces are brought down. 
> 
> Try latest kexec tools from:
> 
> http://www.vergenet.net/~horms/linux/kexec/kexec-tools/testing/kexec-tools-testing-20071017-rc.tar.gz

Good to have a newer version, I'll try that, too.


-- 
Tomasz Chmielewski
http://wpkg.org

