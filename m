Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbXKFNf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbXKFNf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 08:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbXKFNfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 08:35:13 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:45219 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752237AbXKFNfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 08:35:11 -0500
Date: Tue, 6 Nov 2007 14:34:46 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>, akpm@osdl.org,
       torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071106133446.GI26163@stusta.de>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu> <20071106063305.GA26163@stusta.de> <C1C917F8-57EA-434C-9FD8-CB5A4EAF2653@mac.com> <20071106085651.GC26163@stusta.de> <20071106113359.GA6041@ubuntu> <20071106114738.GH26163@stusta.de> <1865922a0711060423ue81dbdct413b993e727f6f9@mail.gmail.com> <46B300CD-7A35-4E81-A0AE-EC2BB72016DD@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46B300CD-7A35-4E81-A0AE-EC2BB72016DD@mac.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 07:49:26AM -0500, Kyle Moffett wrote:
> On Nov 06, 2007, at 07:23:36, Ahmed S. Darwish wrote:
>> On 11/6/07, Adrian Bunk <bunk@kernel.org> wrote:
>>> On Tue, Nov 06, 2007 at 01:34:05PM +0200, Ahmed S. Darwish wrote:
>>>> As far as I understand the problem now, isspace() accepts the 0xa0 
>>>> character which might collide with some of UTF-8 encoded characters 
>>>> cause the high bit is set.
>>
>> I admit I'm not experienced in such encoding stuff, but shouldn't the 
>> ASCII and the ASCII-compatible UTF-8 encodings be enough for the labels?
>>
>>> It would not work if someone would e.g. give you UTF-16 encoded strings, 
>>> but I don't see this happening in practice.
>>
>> Won't this complicate the code too much ?
>
> Well the VFS (for example) certainly doesn't support any encodings other 
> than various extended-ASCII forms (which includes UTF-8).  Something like 
> UTF-16 has extra null characters in-between every normal character, and as 
> such would fail completely if passed to the VFS.

Good point.

> Personally I think that isspace() accepting character 0xA0 is a bug, as 
> there are several variants of extended ASCII only one of which has that 
> character as a space.  Others have it as á (accented A), etc.

But even then Smack would still have a similar problem with isgraph().

> In addition 
> the "canonical" internal text format of the kernel is UTF-8 as that 
> encoding can represent any character in any other encoding and it is 
> backwards-compatible with traditional ASCII.
> 
> Cheers,
> Kyle Moffett-

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

