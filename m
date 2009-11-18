Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbZKRPsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbZKRPsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 10:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbZKRPsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 10:48:04 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:41510 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220AbZKRPsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 10:48:03 -0500
Date: Wed, 18 Nov 2009 16:48:08 +0100
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.31 - very swap-happy with plenty of free RAM
Message-ID: <20091118154808.GE13902@gamma.logic.tuwien.ac.at>
References: <20091005011626.GH4335@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0c067900911172356n2717ce9dn8a4231345903fde6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

(please Cc)

Thanks Dan for your email, it was very enlightening!!!

I have seen that post I am replying to:

On Mon, 18 Nov 2009, Dan Merillat wrote:
> 1.7gb of disk cache, 750 meg of free RAM, and it swaps out 300meg in a
> matter of seconds when given access to a swapfile, then thrashes the
> disk like crazy because that RAM was actively in use. From an
> interactivity standpoint the machine is unusable - 1-2 second pauses
> on mouse movement, 10-15 seconds for the window manager to change
> window focus, keypresses take 1-2 seconds to show up, etc.  When I
> issue a swapoff it takes 10-15  minutes for it to slowly pull it all
> back in - once it's done I run fine.


And back in the beginning of October I reported something very similar:


On Mo, 05 Okt 2009, preining wrote:
> I am experiencing IO stalls of real serious dimensions. I mean up to 20secs
> waiting for some operations.
> 
> That normally happeny when I do a svn up on a big subversion repository,
> but even on other locations.
> 
> Yesterday a simple sync took 30sec although I was not doing anything else.


So what normally trashed my system to a quasi halt I tried after a swapoff -a,
*two* svn up of really big repositories (some Gb), plus starting 
VirtualBox Windows XP with 1Gb virtual RAM on a 2Gb machine.

And see hoho, no problem at all. Everything remains responsive and happy.
The memory was never above 60% in use, but 40% in cache, and all 
without any problems.

So that seems to be a real bug.

I am running currently 2.6.32-rc7, but experienced that already in the
31-rc version. Hard to pinpoint exactely where it happens.

If I can run some patches *please* let me know.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining                                        Associate Professor
JAIST Japan Advanced Institute of Science and Technology   preining@jaist.ac.jp
Vienna University of Technology                               preining@logic.at
Debian Developer (Debian TeX Task Force)                    preining@debian.org
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
GLENWHILLY (n. Scots)
A small tartan pouch worn beneath the kilt during the thistle-harvest.
			--- Douglas Adams, The Meaning of Liff
