Return-Path: <linux-kernel-owner+w=401wt.eu-S1758922AbXLTURV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbXLTURV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbXLTURM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:17:12 -0500
Received: from iriserv.iradimed.com ([72.242.190.170]:16943 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753342AbXLTURL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:17:11 -0500
Message-ID: <476ACDBE.2070600@cfl.rr.com>
Date: Thu, 20 Dec 2007 15:17:02 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Lutomirski <luto@myrealbox.com>
CC: Theodore Tso <tytso@mit.edu>, David Newall <david@davidnewall.com>,
       John Reiser <jreiser@bitwagon.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
References: <20071214201305.GL19691@waste.org>  <20071214232322.GE17344@thunk.org> <47632010.6030709@BitWagon.com>  <20071215043208.GF17344@thunk.org> <4766A40D.4080804@BitWagon.com>  <20071217173623.GC7070@thunk.org> <476719E5.1010505@myrealbox.com>  <2007121803053 <cb0375e10712192018l66671b34r1680077765e89fb0@mail.gmail.com>
In-Reply-To: <cb0375e10712192018l66671b34r1680077765e89fb0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Dec 2007 20:17:19.0797 (UTC) FILETIME=[529E4E50:01C84345]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15618.001
X-TM-AS-Result: No--12.240700-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Lutomirski wrote:
> I understand that there's no way that /dev/random can provide good
> output if there's insufficient entropy.  But it still shouldn't leak
> arbitrary bits of user data that were never meant to be put into the
> pool at all.

It doesn't leak it though, it consumes it, and it then vanishes into the 
entropy pool, never to be seen again.

> Step 1: Boot a system without a usable entropy source.
> Step 2: add some (predictable) "entropy" from userspace which isn't a
> multiple of 4, so up to three extra bytes get added.
> Step 3: Read a few bytes of /dev/random and send them over the network.

Only root can do 1 and 2, at which point, it's already game over.

