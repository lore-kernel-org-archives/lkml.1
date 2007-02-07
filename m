Return-Path: <linux-kernel-owner+w=401wt.eu-S1161227AbXBGLrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161227AbXBGLrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 06:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161229AbXBGLrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 06:47:25 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:34130 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161227AbXBGLrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 06:47:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G2PVy71zpJu1dCzzZ3ot/FCf64ovq9Hwr0+Aw6SiPcCYWHcoNt21l5d/6jPGQdSf494ZWoVHzlrCpJvDHXCgLGcyFFlo4BSRR6mUycMShG4PBM5aO+3nogVZLagCY/JMT2jSRnD4bS+cyMIDrM9q5QkeDpm8+/zk84z1ey7dAzQ=
Message-ID: <8d158e1f0702070347n4398c878i1b591d09e9c25d48@mail.gmail.com>
Date: Wed, 7 Feb 2007 12:47:23 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Adam J. Richter" <adam@yggdrasil.com>
Subject: Re: hdparm for lib_pata
Cc: Stephen.Clark@seclark.us, linux-kernel@vger.kernel.org
In-Reply-To: <200702071055.l17AtrZf014135@freya.yggdrasil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702071055.l17AtrZf014135@freya.yggdrasil.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>         Do you know if these drives were advertising less capability
> than they were spec-ed at?  Do you recall if the IDE driver without
> kernel arguments printed its rationale for reverting to the slower
> setting?

I can only speak for myself of course.
On boot time the libsata driver detected my harddisks were capable of
UDMA100, and used it.

Then, after 2 hours, and resyncing RAID1 MD 1 devices, I started
seeing things like:
"Drive not ready"
"DMA timeout on ..."

After this, I saw a bus reset, the master disk (the one with problems)
reverted to UDMA/44 and the slave (no problems appearantly staid
(stayed?) at UDMA100.

Then, after literaly some minutes, same messages, "Drive not ready" ,
"DMA timeout". And it went to an even lower UDMA mode, till the point
it was out of UDMA modes, switched to PIO, and when it dropped to the
lowest PIO mode, it just said how it couldnt go any lower

>         I ask because I'd like to know if this sort of thing can ever
> happen with libata.  If so, then that is yet another reason to have
> the ability to override DMA settings from user level in libata.

Please note: I DID have problems, major ones, So yes, libsata does
fall back to slower transfer modes, but as far of my experience
concerned, not without a reason which should be addressed.


Patrick
