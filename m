Return-Path: <linux-kernel-owner+w=401wt.eu-S1761680AbYHDGx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761680AbYHDGx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760524AbYHDGxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:53:40 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:6276 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761502AbYHDGxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:53:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=C4RDITgsnmbel5ouypyE13zKdzNkACzFKKP7zN7fwd86mjhxZfrTGr+BT53UZn0Lvw
         N5m+vWUomLSXdqCEjDd34I9K1X45IlkqbTcC9xXjLK3muGzf0+uzwhnrYvqtECoGHi0W
         A5uCpJu3dU11cB3WAcG/23A0qWApRaiMWL++4=
Message-ID: <21d7e9970808032353m40fcea6dtbf1b7bc1c5cf06d9@mail.gmail.com>
Date: Mon, 4 Aug 2008 16:53:37 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Shaohua Li" <shaohua.li@intel.com>
Subject: Re: [patch 0/2] reduce agpgart memory allocation time
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@redhat.com>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <1217832677.21811.7.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217832677.21811.7.camel@sli10-desk.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2008 at 4:51 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> agpgart memory allocation is quite expensive. For each page agpgart
> allocated, it changes the page to uc and as result flush tlb/cache for
> the page. In my test, Intel Xorg driver takes about 0.2s for a 32M 3D
> fb, and the total time for memory allocation is about 0.33s when intel
> xorg driver initializes. Below patches fix the gap. It can reduce the
> time to 0.03s, so xserver can boot 0.3s faster.
>

This approach is quite like what was there before, and I think was
objected to on the grounds the caller might forget to
call the flush and leave the system in an inconsistent state.
Personally I've never bought that argument, its not like we have
thousands of users for this API.

I proposed an alternative interface but I failed to get it merged and
ran out of time
http://www.ussg.iu.edu/hypermail/linux/kernel/0804.3/1112.html

I was trying to get the cpa interface to allow arrays of pages to be
passed in, I was then going to change AGP like
http://git.kernel.org/?p=linux/kernel/git/airlied/agp-2.6.git;a=shortlog;h=agp-pageattr2

I really should fix those patches up at some point, feel free to base
a system on those if someone objects to the method with the call site
doing the flush.

Dave.
