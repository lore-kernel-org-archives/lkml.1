Return-Path: <linux-kernel-owner+w=401wt.eu-S933527AbXCEPh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527AbXCEPh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933525AbXCEPh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:37:27 -0500
Received: from lazybastard.de ([212.112.238.170]:53434 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932963AbXCEPh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:37:26 -0500
Date: Mon, 5 Mar 2007 16:33:27 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
       alex@clusterfs.com, suzuki@in.ibm.com
Subject: Re: [RFC] Heads up on sys_fallocate()
Message-ID: <20070305153326.GA1469@lazybastard.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <45EB4A55.3060908@redhat.com> <20070305001621.GB18691@lazybastard.org> <200703050136.37181.arnd@arndb.de> <20070305114109.GA454@lazybastard.org> <45EC3253.2030206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45EC3253.2030206@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 March 2007 07:08:03 -0800, Ulrich Drepper wrote:
> Jörn Engel wrote:
> > Does the allocation have to be persistent beyond lifetime of the file
> > descriptor?
> 
> Of course.  You call posix_fallocate once for the lifetime of the file
> when it is created to ensure that all future uses will work.

That part is not quite clear from the manpage but I trust most people
would assume the same.

> It seems your filesystem will not be able to support this unless
> compression is turned off.

Correct.  Compression needs to be turned off for a file, if
posix_fallocate(3) is to succeed.  What I could do is disable
compression (meaning that no data written in the future will be
compressed) and rewrite all blocks within the given range.

Still, it is quite obvious that noone designing this interface has lost
much thought to compressing filesystems.  Whatever I can come up with
will either be incompatible or some sort of hack.  :(

Jörn

-- 
Courage is not the absence of fear, but rather the judgement that
something else is more important than fear.
-- Ambrose Redmoon
