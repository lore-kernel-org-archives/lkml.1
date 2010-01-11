Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139Ab0AKAOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab0AKAOI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 19:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500Ab0AKAOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 19:14:06 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49129 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751406Ab0AKAOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 19:14:05 -0500
Date: Mon, 11 Jan 2010 00:17:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Goller <morfic@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: staging/et131x Driver Transmits but does not Receive Packets
Message-ID: <20100111001745.21d28340@lxorguk.ukuu.org.uk>
In-Reply-To: <13bb8ce11001101156g3cd88a6bn7c6ce657850ab534@mail.gmail.com>
References: <13bb8ce11001101156g3cd88a6bn7c6ce657850ab534@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I will gladly provide any further info you require to look into this.
> 
> Thank you in advance for your time,

There are a huge series of small patches applied to the driver so the
first step to finding which one broke your card is to find which release
or rc it breaks upon and then to narrow down to which patch.

The easiest way if you don't mind a lot of building is to use the git
tree and git bisect.

The basic idea is to pull a kernel git tree (so that it has all the
patches and meta data) then do

git-bisect reset		# Starting a new bisect
git-bisect start
git-bisect good v2.6.31-rc1	# Or whatever you know worked (later
				# the better)

git-bisect bad v2.6.32-rc3	# Earliest you know is broken (or miss
				# version for 'current')


It'll then generate a tree half way between the two

Then build a kernel and test it. If it works

git-bisect good

If not 

git-bisect bad

and it'll pick another spot half way between the two until it pins down
the offender.

If you get one that won't build/fails for some other reason you can 
git-bisect skip

to bump on one

It'll quite rapidly pin down the offending change if you've got a
repeatable bug.

