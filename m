Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbYHUQP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbYHUQP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYHUQPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:15:48 -0400
Received: from outbound-mail-113.bluehost.com ([69.89.24.3]:43060 "HELO
	outbound-mail-113.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752684AbYHUQPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:15:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Gv6PpHMxNoccybdqrfnH2s50W1V3PHzcrqoVy5eRgmj5J4YrABAsTqwfXx94fNZmUpbybobJ2NfAGsAnwLawx+p90RRxE7279gRe62XfWnJ2kplSqvPd/PblFYxWXVKZ;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jerome Glisse <glisse@freedesktop.org>
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Date: Thu, 21 Aug 2008 09:15:33 -0700
User-Agent: KMail/1.9.9
Cc: Keith Packard <keithp@keithp.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Dave Airlie <airlied@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
References: <1217573919-7496-1-git-send-email-eric@anholt.net> <200808191150.12345.jbarnes@virtuousgeek.org> <20080821154259.a57d8bb6.glisse@freedesktop.org>
In-Reply-To: <20080821154259.a57d8bb6.glisse@freedesktop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808210915.33926.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 21, 2008 6:42 am Jerome Glisse wrote:
> On Tue, 19 Aug 2008 11:50:11 -0700
>
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > As for in-kernel stuff, as long as we keep the GEM shmem hooks separate
> > from the actual bookkeeping (like we do now with i915_gem_create_ioctl()
> > vs drm_gem_object_alloc() for example) we should be able to do the
> > in-kernel stuff w/o jumping through too many VFS/VM hoops.  That would
> > also assume we don't care about swapping in the in-kernel case, which we
> > don't; we want to pin the kernel allocated frame buffer and other memory
> > anyway, so using the internal functions should be fine.
>
> What about suspend to disk ? How do we save such buffers ?

We'll have to deal with it like other kernel memory, or in the case of cards 
with VRAM maybe have a special hook that copies out the front buffer.  
Depends on how Dave implemented the GEM stuff on a device with VRAM (I 
haven't looked yet).

> Btw i think that GTT looks a lot like IOMMU, i don't know the IOMMU kernel
> side API that much, but from memory i think that you have call to ask IOMMU
> mapping why not do somethings like that for GTT ?
>
> You get normal mapping of object diret but userspace can ask some kind of
> GTT mapping on a given object. Anyway new flag on fd sounds good enough
> too.

At a high level that's pretty much what we're doing.  We already have to map 
things through the GTT in the kernel for pwrite/pread etc., so that code is 
done.  It's just exposing it to userspace that's a bit of a pain, since we 
have an all-ioctl interface...

-- 
Jesse Barnes, Intel Open Source Technology Center
