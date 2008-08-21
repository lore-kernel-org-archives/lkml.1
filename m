Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbYHUOLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbYHUOLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYHUOLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:11:12 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:20432 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbYHUOLK (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:11:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xfMkFXGvJUm+W2E6mA1Hr9hMP8wRzAYj+KUip0js9kZfmKSpJQ0hfEE0Vp01+Rs9P+
         mEp6ibYUEB8603+QmLBmBZKkrx3crvatEgJMtiKo446gLrDM5RlVn9FkZ3aWGUEohlWo
         TfLPsjeDhf0diVupqpWHfLR0F5gjZM2TZuDeo=
Message-ID: <6934efce0808210711t686a88eci6eb294dbb54d68fe@mail.gmail.com>
Date: Thu, 21 Aug 2008 07:11:08 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Jamie Lokier" <jamie@shareable.org>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <20080821110749.GA1926@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00C4.6060302@gmail.com> <20080821110749.GA1926@shareable.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How does it fare with no MMU?  Can the profiler and image builder lay
> out the XIP pages in such a way that no-MMU mmaps can map those regions?
>
> No complaint if not, it would be a nice bonus though.

Sorry.  I don't believe it will work on no-MMU as is.  That said you
_could_ tweak the mkfs tool to lay mmap()'ed regions down contiguously
but then if you mmap() an unprofiled region, well that would be bad.
I suppose you could make axfs_mmap smart enough to handle that.  I
guess the cleanest way would be to just make files lay down
contiguously, you lose some of the space saving but it would work.

I'm not plannin to get to this anytime soon.  But I'd be willing merge
patches.  Can anybody convince me offline that working on no-MMU this
makes financial sense for my employer?  This is getting to be a common
question.  How many noMMU users are out there and why are you so
interested?
