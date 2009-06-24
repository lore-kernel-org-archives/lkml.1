Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbZFXRrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbZFXRrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761162AbZFXRrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:47:01 -0400
Received: from mail2.shareable.org ([80.68.89.115]:34616 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761156AbZFXRq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:46:59 -0400
Date: Wed, 24 Jun 2009 18:47:00 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Marco <marco.stornelli@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
Message-ID: <20090624174700.GI14121@shareable.org>
References: <2ea1731b0906212333r20deb71q2f021fc79bcc8a8e@mail.gmail.com> <20090622172003.GB21149@elf.ucw.cz> <4A3FBFF0.40006@am.sony.com> <20090622173704.GC21299@elf.ucw.cz> <4A3FC84A.6060608@gmail.com> <20090622204031.GA24236@elf.ucw.cz> <4A3FFC89.4070006@am.sony.com> <20090622215753.GA25434@elf.ucw.cz> <4A4119DB.4030203@gmail.com> <20090623182941.GA2045@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623182941.GA2045@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Tue 2009-06-23 20:07:23, Marco wrote:
> > You are talked about journaling. This schema works well for a disk, but
> > what about a piece of ram? What about a crazy kernel that write in that
> > area for a bug? Do you remember for example the e1000e bug? It's not
> 
> I believe you need both journaling *and* write protection. How do you
> handle power fault while writing data?

I think this is basically right.

write protection for the crazy kernels, and journalling for
powerfail/crash during updates.

Journalling can be extremely simple.  It can be just one memory block
at a fixed location, double-buffering all writes.

Pramfs already has checksums, which makes that easier.  You just write
to the buffer area first, with checksum, then write to the final area.
Mount looks at the buffer area, and if the checksum is fine, copies
the contents to the destination block.

That's all it takes to be resistant against power failures and crashes
during writes.  Probably <100 lines of code.

-- Jamie
