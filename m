Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbZHXWWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbZHXWWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 18:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbZHXWWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 18:22:44 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:37034 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753805AbZHXWWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 18:22:44 -0400
Message-ID: <4A93129E.6080704@acm.org>
Date: Mon, 24 Aug 2009 16:22:22 -0600
From: Zan Lynx <zlynx@acm.org>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>
CC: Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
References: <200903161426.24904.rob@landley.net> <20090323104525.GA17969@elf.ucw.cz> <87ljqn82zc.fsf@frosties.localdomain> <20090824093143.GD25591@elf.ucw.cz> <82k50tjw7u.fsf@mid.bfk.de> <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <4A930EB9.8030903@redhat.com>
In-Reply-To: <4A930EB9.8030903@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20090824/1Mfhvi-00087a-CL-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler wrote:
> Pavel Machek wrote:
>> Degraded MD RAID5 does not work by design; whole stripe will be
>> damaged on powerfail or reset or kernel bug, and ext3 can not cope
>> with that kind of damage. [I don't see why statistics should be
>> neccessary for that; the same way we don't need statistics to see that
>> ext2 needs fsck after powerfail.]
>>                                     Pavel
>>   
> What you are describing is a double failure and RAID5 is not double 
> failure tolerant regardless of the file system type....

Are you sure he isn't talking about how RAID must write all the data 
chunks to make a complete stripe and if there is a power-loss, some of 
the chunks may be written and some may not?

As I read Pavel's point he is saying that the incomplete write can be 
detected by the incorrect parity chunk, but degraded RAID-5 has no 
working parity chunk so the incomplete write would go undetected.

I know this is a RAID failure mode. However, I actually thought this was 
a problem even for a intact RAID-5. AFAIK, RAID-5 does not generally 
read the complete stripe and perform verification unless that is 
requested, because doing so would hurt performance and lose the entire 
point of the RAID-5 rotating parity blocks.

-- 
Zan Lynx
zlynx@acm.org

"Knowledge is Power.  Power Corrupts.  Study Hard.  Be Evil."
