Return-Path: <linux-kernel-owner+w=401wt.eu-S934142AbYF3Vws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142AbYF3Vws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932348AbYF3VmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:42:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:26158 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933563AbYF3Vl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:41:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LiDqatJn8p0N1OnHLtLDzyIEZGuegMv3oeShagUZOQzl0is4NqcuvmwO2ft6o9hwXu
         pksqmuxJalAi4su0a3tA8GqZnBAbUCzpPXHwozqwX6xXV2NTJiXXIFt7++o0Wd4NMsna
         WV8gm4oXXafaRv4RATE8Av+jH1tY+YjMFlujU=
Message-ID: <19f34abd0806301441w52a9d9e7h42336e05e10f32a9@mail.gmail.com>
Date: Mon, 30 Jun 2008 23:41:55 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: mmiotrace broken in linux-next (8-bit writes only)
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Steven Rostedt" <srostedt@redhat.com>, proski@gnu.org,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <20080630234837.118fff8c@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080628214626.5f9199d7@daedalus.pq.iki.fi>
	 <20080630123736.GA4011@elte.hu>
	 <20080630234837.118fff8c@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 10:48 PM, Pekka Paalanen <pq@iki.fi> wrote:
> On Mon, 30 Jun 2008 14:37:36 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
>
>> it would also be nice if you could check whether ftrace as integrated
>> into linux-next has a functional mmiotrace. (and work with me in -tip on
>> fixing it if it doesnt)
>
> I tested it and it is broken in two ways. First is the NULL pointer
> dereference, for which I made a quick patch (in the end of this email)
> and I don't know what is going on in there. The patch allows me to run
> my simple test. However, the test shows, that all 8-bit MMIO writes are
> recorded with datum 0x80, which is incorrect. I've no idea what could
> have changed. All the 16 and 32-bit ops are ok, and so are 8-bit reads,
> which means the writes really do happen with the correct data, but just
> mmiotrace gets it wrong. Mmiotrace source files are unchanged.
>
> Has there been changes in compiler flags or iowrite8() that would cause
> different instructions to be used in implementing the MMIO write?
> I'm completely baffled.
>
> I guess I should try to bisect, but I don't know when I can do that.
> I tested on Athlon64, 64-bit UP kernel.
>
> Vegard, have you experienced any weird issues in instruction decoding?
> But I guess sort of bug would not affect you, since kmemcheck is not
> interested in the data.

No. But kmemcheck is not in -next yet either AFAIK :-)

I'll test the latest tip/master and see if I can try out mmiotrace as
well. But you are right, kmemcheck is not interested in the data.

(BTW, Ingo, Pekka E., I had an additional idea for kmemcheck: We can
record a checksum of bytes that are written and compare them with the
actual value when they are next read. If they differ, we are either
dealing with DMA memory or bad RAM. But this is long into the future..
:-))

Can you please post a few IPs that give you byte-writes with 0x80
value, then post the disassemblies of those IPs? Also, a chunk of the
log would be nice, just so we know what it looks like.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
