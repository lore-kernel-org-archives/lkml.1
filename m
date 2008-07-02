Return-Path: <linux-kernel-owner+w=401wt.eu-S1763660AbYGBLId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763660AbYGBLId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbYGBLIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:08:25 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:5789 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbYGBLIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:08:25 -0400
To: "Rob Mueller" <robm@fastmail.fm>
Cc: "Michael Kerrisk" <mtk.manpages@googlemail.com>,
       "Bron Gondwana" <brong@fastmail.fm>,
       "Philippe De Muyter" <phdm@macqel.be>, <linux-kernel@vger.kernel.org>
Subject: Re: mmap'ed memory in core files ?
From: Andi Kleen <andi@firstfloor.org>
References: <20080701132149.GA32510@frolo.macqel>
	<517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com>
	<20080701214423.GA29875@brong.net>
	<cfd18e0f0807012214o78353faal84a5fa764d3210bf@mail.gmail.com>
	<3f2201c8dc0d$d1012d60$0b01a8c0@robmhp>
Date: Wed, 02 Jul 2008 13:07:22 +0200
In-Reply-To: <3f2201c8dc0d$d1012d60$0b01a8c0@robmhp> (Rob Mueller's message of "Wed, 2 Jul 2008 16:35:22 +1000")
Message-ID: <87vdzosfx1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Jul 2008 11:00:01.0204 (UTC) FILETIME=[C6372F40:01C8DC32]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rob Mueller" <robm@fastmail.fm> writes:
>
> It's clearly sparse, but slightly unintuitive that the ulimit doesn't
> actually limit the filesize, just the size of the data written to the
> file.

It's the only sane semantic. Imagine ulimit would limit the address
range as you seem to be asking for. This means if you set e.g. ulimit
-c 1G then the kernel would never dump any address (mmap or not) above
1GB. Never dumping the process stack for example. Clearly doesn't make
any sense. And mmap'ed files are not different from any other 
mappings in this regard.

-Andi
