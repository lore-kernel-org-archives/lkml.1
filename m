Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbZFZAqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbZFZAqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 20:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbZFZAqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 20:46:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:42169 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbZFZAqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 20:46:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=GhdB1dqG3G4E7FlptNsEG5cXKvN+M1MPvuZIU01e9cV/UrZvJlxuhXa/rRkP72b5jN
         ZM21Rb7RU/q19WR7Qo+gfKlGQ6GdiRyTWXwo2sAsjfN5f0GDRU0WLTkcgS6xu9XCA7jU
         hM4q2FRaMFWulJCZdTb8cZobf/PbCMwplcnKc=
Message-ID: <4A441A69.1010803@gmail.com>
Date: Fri, 26 Jun 2009 09:46:33 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Niel Lambrechts <niel.lambrechts@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <clqON-2Xv-7@gated-at.bofh.it>	<cmknZ-8lW-9@gated-at.bofh.it>	<cmoBl-6Ok-21@gated-at.bofh.it>	<cmp4n-7rb-15@gated-at.bofh.it>	<cmsYg-5BR-27@gated-at.bofh.it>	<cmvW7-1Yj-23@gated-at.bofh.it>	<cnheh-3vO-7@gated-at.bofh.it>	<cnPg1-7Q4-19@gated-at.bofh.it>	<cnTWo-7bV-25@gated-at.bofh.it>	<co1Kd-350-5@gated-at.bofh.it>	<co2Qf-4QQ-27@gated-at.bofh.it>	<co4yj-7Mc-5@gated-at.bofh.it>	<cp71c-4py-29@gated-at.bofh.it>	<cEVyE-re-1@gated-at.bofh.it>	<4A17C39E.2030302@gmail.com>	<4A19F006.3000303@kernel.org> <20090525091534.13ae103c@lxorguk.ukuu.org.uk> <4A1B164B.1010108@gmail.com> <4A1B76EB.9040500@kernel.org> <4A1B8193.1010703@gmail.com> <4A1B8328.80801@kernel.org> <4A1B8873.1040101@gmail.com> <4A1BEFB6.80205@kernel.org> <4A1C316C.9040201@gmail.com> <4A1C8444.9040605@kernel.org> <4A1D47C6.1070504@gmail.com> <4A2424A2.5020704@gmail.com> <4A25EA78.7070705@kernel.org> <4A25FBD1.70000@gmail.com> <4A2A1521.5020407@gmai l.com> <4A437442.8000909@gmail.com> <4A4396E9.1030509@gmail.co
 m>
In-Reply-To: <4A4396E9.1030509@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Niel.

Niel Lambrechts wrote:
> I've recently switched my root partition from OpenSUSE 11.1 to Fedora 11
> and since then I've not again seen the issue. I'm still using vanilla
> 2.6.30 generated with the same .config and EXT4 as before, so I have no
> idea why I cannot reproduce the issue. I still use hibernate + sleep
> frequently, and I just checked - I have 5 days uptime with a mount count
> of 20 and the file-system is still clean.
> 
> The one big difference is that my original partition was a EXT2 -> EXT3
> -> EXT4 upgrade job over a long period of time, and some of the EXT4
> parameters now used by Fedora 11 on the reformatted root partition are
> different from what I had then. Here is a summary of the differences in
> case it matters at all:
> 
> Current settings:
> Default mount options:    user_xattr acl
> Inodes per group:         8192
> Inode blocks per group:   512
> Flex block group size:    16
> Required extra isize:     28
> Desired extra isize:      28
> Default directory hash:   half_md4
> 
> Previous settings:
> Default mount options:    (none)
> Inodes per group:         8176
> Inode blocks per group:   511
> Default directory hash:   tea
> 
> If I do notice any such errors again I'll apply the debug patch and let
> you know, but it does seem as if the upgrade made this issue disappear...

Eh... if my analysis is correct the bug will be dependent on some
non-deterministic things including timing and layout of blocks of the
file which the filesystem touchs during suspend/resume.  I'm fairly
sure the problem is still there.  Oh well, it seems I'll have to
construct a synthetic case to test it.  Anyways, please let me know if
you encounter the problem again.  I'll keep you in loop with further
patches.

Thanks.

-- 
tejun
