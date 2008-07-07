Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbYGGNdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbYGGNdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 09:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbYGGNdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 09:33:46 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:12204 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbYGGNdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 09:33:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QukE0pmNi/TmXSY2wGeMXqzkioBMwi4DQlx1syCV8T8LBq2SgDK5owEOapLK0BSzpA
         x6ivKBhHz0MkaU13awqVLv6QG+V0urUUF9SUeqT5RCnBPazYbpRPLFrmG/m8cDYB3nZN
         uYNhWr5cAHn2ufda6ZCcKo9J41zesnjnckEE4=
Message-ID: <19f34abd0807070633y337486cek34f8fea6bbbf37f1@mail.gmail.com>
Date: Mon, 7 Jul 2008 15:33:42 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Carl-Daniel Hailfinger" <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: [Linux-NTFS-Dev] Oops with corrupted NTFS image
Cc: "Eric Sesterhenn" <snakebyte@gmx.de>, linux-ntfs-dev@lists.sourceforge.net,
       "Anton Altaparmakov" <aia21@cam.ac.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <48721996.8050708@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080706172147.GA19559@alice>
	 <F2EEF4B5-3E11-480A-93E7-9078BDC578EA@cam.ac.uk>
	 <20080707122450.GC19313@alice>
	 <19f34abd0807070603p23b30372l5bee26b05b6fa9c7@mail.gmail.com>
	 <48721996.8050708@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2008 at 3:26 PM, Carl-Daniel Hailfinger
<c-d.hailfinger.devel.2006@gmx.net> wrote:
>> which is...
>>
>>         vi->i_mtime = ntfs2utc(si->last_data_change_time);
>>
>> which is probably what is causing the NULL pointer dereference.
>>
>
> The problem of this theory is that there is no NULL pointer dereference,
> unless you meant "invalid memory access".

Oops, yeah. I skipped a line, but page fault nonetheless ;-)

The rest of the theory should still hold. The pointer being
dereferenced is held in %eax, which is c6798550. This fits with the
reported address:

[   76.583958] BUG: unable to handle kernel paging request at c6798558
...
[   76.584019] EAX: c6798550 EBX: 00000000 ECX: c678b000 EDX: c678b038

Thanks for the correction.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
