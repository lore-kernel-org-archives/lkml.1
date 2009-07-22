Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbZGVXGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbZGVXGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 19:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbZGVXGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 19:06:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565AbZGVXGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 19:06:16 -0400
From: "NeilBrown" <neilb@suse.de>
To: "mark delfman" <markdelfman@googlemail.com>
Date: Thu, 23 Jul 2009 09:06:07 +1000 (EST)
Message-ID: <bde080c5e5b50b0cb99492dd561190bd.squirrel@neil.brown.name>
In-Reply-To: <66781b10907220204o26964a70j90348ec78a685b52@mail.gmail.com>
References: <66781b10907220204o26964a70j90348ec78a685b52@mail.gmail.com>
Subject: Re: RAID60 - MD / LVM
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, July 22, 2009 7:04 pm, mark delfman wrote:
> Hi All,
>
> Firstly let me apologise for what maybe a simple question, I have
> tried to google and search this out.
>
> The question is simply ‘the best way to create a RAID60 or any nested
> RAID’.  Looking at the examples it seems the approach is to create 2 x
> RAID6’s and then simply RAID0 on top.  However, is there any advantage
> in using MD to create the RAID0 or would you see the same overall
> result by using LVM to stripe (R0) the 2 x RAID6’s?

Most of the difference between using MD and LVM to do the striping would
be simply in the fact that different tools are used, so the best advice
would probably be to use whatever you are more familiar with.
In 2.6.31, md/raid0 will support a chunk size that is not a power of
2.  I don't think LVM supports that (yet).
That was added specifically for this sort of set up, so that the
RAID0 chuck can align with the RAID6 stripe.  Exactly how important
that alignment is probably depends on your workload.  I haven't really
thought it though enough to be able to give any guidance.


>
> Given that I see a lot of post’s RE: RAID10, then I ‘suspect’ that the
> MD RAID0 code has some understanding of or tuning for nested RAID’s,
> which I guess LVM may not have.

MD has a separate RAID10 module which stripes multiple copies of the
data across multiple drive.  It is simpler and more flexible than
RAID0 over RAID1.  There is no similar RAID60 module as there is a lot
less room for gains in flexibility.

>
> It would seem the answer is obvious as it makes sense to simply use
> MD, but we have an internal system based on 100’s of old scripts and
> the RAID section only allows us to select  ‘drives’ (not raids), it
> does however use LVM so it would be easier to change the script which
> created the VG as opposed to change the many scripts related to RAID
> creation...

I guess that is your answer then - use LVM over MD.

>
> If there is a real disadvantage in using LVM, then we can manually
> create the RAID’s I guess....

I haven't used LVM in this configuration so I cannot report first
hand experience, but I would be very surprised if LVM did not meet
your needs.

NeilBrown


>
>
>
> I would appreciate any feedback
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

