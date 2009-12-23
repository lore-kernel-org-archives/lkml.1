Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbZLWO3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbZLWO3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 09:29:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbZLWO3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 09:29:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756040AbZLWO3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 09:29:01 -0500
Message-ID: <4B32290D.8090008@redhat.com>
Date: Wed, 23 Dec 2009 16:28:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Anthony Liguori <anthony@codemonkey.ws>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <200912231407.20130.bzolnier@gmail.com> <4B321B9F.6030707@redhat.com> <200912231508.25355.bzolnier@gmail.com>
In-Reply-To: <200912231508.25355.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 04:08 PM, Bartlomiej Zolnierkiewicz wrote:
>
>> The device model is exposed to the guest.  If you change it, the guest
>> breaks.
>>      
> Huh?  Shouldn't non-vbus aware guests continue to work just fine?
>    

Sure.  But we aren't merging this code in order not to use it.  If we 
switch development focus to vbus, we have to ask everyone who's riding 
on virtio to switch.  Alternatively we maintain both models.

If vbus was the only way to get this kind of performance, I know what 
I'd choose.  But if it isn't, why inflict the change on users?

Consider a pxe-booting guest (or virtio-blk vs. a future veblk).  Is 
switching drivers in initrd something you want your users to do? [1]

One of the advantages of virtualization is stable hardware.  I don't 
want to let it go without a very good reason.

[1] I remember the move from /dev/hda to /dev/sda a few years ago, it 
isn't a good memory.

-- 
error compiling committee.c: too many arguments to function

