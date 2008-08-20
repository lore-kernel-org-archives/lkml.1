Return-Path: <linux-kernel-owner+w=401wt.eu-S1757149AbYHTPkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbYHTPkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbYHTPkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:40:31 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:27332 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257AbYHTPka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:40:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Oz2p/15K6OxOTh6y13G1i9HbW/0TiLmMFFVrh3vZBA95AS4jugBK0W9+gQm5HDPZaG
         dAzktZBrHPki1Q0NcAyY7tpsSDvVd9wMnHO9Rui8gyznENjYQjlIgrxsCm040aTF6rpS
         zl54TPri5B5rL19i4tkBx1T+eYMfdnXbiYm/8=
Message-ID: <19f34abd0808200840v17a8e5d4ge60c332f864abd81@mail.gmail.com>
Date: Wed, 20 Aug 2008 17:40:29 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "the arch/x86 maintainers" <x86@kernel.org>
Subject: Re: latest -git: BUG: unable to handle kernel paging request (numaq_tsc_disable)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0808200828o6496cbeap75b7242845e96ef3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808200828o6496cbeap75b7242845e96ef3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 5:28 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Hi,
>
> This actually hardlocked my machine and I had to add an extra patch to
> get any output at all. Base version is latest git, commit
> 1fca25427482387689fa27594c992a961d98768f.
>

...

> Booting processor 1/1 ip 6000
> <1>BUG: unable to handle kernel paging request at c08a45f0
> <1>IP: [<c08a45f0>] numaq_tsc_disable+0x0/0x40
> <0> [<c0678676>] ? init_intel+0x196/0x360

Seems to be a section mismatch; init_intel() is __cpuinit while
numaq_tsc_disable() is __init. Seems to be introduced in:

commit 64898a8bad8c94ad7a4bd5cc86b66edfbb081f4a
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Sat Jul 19 18:01:16 2008 -0700

    x86: extend and use x86_quirks to clean up NUMAQ code


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
