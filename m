Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYAGWza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYAGWza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 17:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYAGWzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 17:55:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57707 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbYAGWzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 17:55:19 -0500
Date: Mon, 7 Jan 2008 23:57:41 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       ebiederm@xmission.com, bcrl@kvack.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: regression: sysctl_check changes in 2.6.24 are O(n) resulting in slow creation of 10000 network interfaces
Message-ID: <20080107225740.GA14758@one.firstfloor.org>
References: <20080106220307.GU28570@kvack.org> <m1ir26ktqi.fsf@ebiederm.dsl.xmission.com> <20080106.231040.222338659.davem@davemloft.net> <p73wsqlqsa9.fsf@bingen.suse.de> <20080107213054.23270044@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080107213054.23270044@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 09:30:54PM +0000, Alan Cox wrote:
> > I think that would be a better option than to complicate sysctl.c
> > for this uncommon case.
> 
> What is so complicated about hashing the entries if you are checking for

One thing I'm worrying about is memory bloat (yes I know that's not
popular but someone has to do it ;-)

You would need a hash table for each table. To handle 100k entries
you would need a larger hash tables with at least a few hundred entries.
And that for each subdirectory.

% find /proc/sys -type d | wc -l
64

Assuming e.g. a 128 byte entry hash table (which is probably too small
for 100k entries) that would require 64 * 128 * 8 = 64k of memory.
Not gigantic, but lots of small fry bloat also adds up. Now if you
chose an actually realistic hash table size it gets even bigger.

Most likely you would need to implement a tree or a resizeable hash table
to do this sanely and then you quickly go into complicated territory.

> duplicates when debugging. You can set the hash function to "0" and the

My understanding was that the code was always on; not only for debugging.

-Andi
