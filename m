Return-Path: <linux-kernel-owner+w=401wt.eu-S1758979AbYE0R75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979AbYE0R75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756934AbYE0R7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:59:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:9569 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104AbYE0R7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:59:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FWEfPZrYl3A1iNpbFtLMmd9JVGYth2Xg7ON7+YyJy1XolO+0SXXUtZorn+vcH2p0k3pDstJ7HXn9jp4X7A5EXnafL0RUe1SJmFrNJxHETyIMausdFwwQF/3mewb1s2fWtG4kD3y31ev3bb7c37MHXENJUIbLlpwJC3KAJYcPBAo=
Message-ID: <84144f020805271059k11498424w3435b748f5254e2e@mail.gmail.com>
Date: Tue, 27 May 2008 20:59:44 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eric Sesterhenn" <snakebyte@gmx.de>
Subject: Re: Redzone overwritten with CONFIG_SECURITY
Cc: linux-kernel@vger.kernel.org, "Chris Wright" <chrisw@sous-sol.org>,
       "James Morris" <jmorris@namei.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080527161148.GA7291@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080526143422.GA3203@alice>
	 <84144f020805270800l5911ed02ia7a92d96a8aa32a7@mail.gmail.com>
	 <20080527151136.GA20750@alice> <20080527161148.GA7291@alice>
X-Google-Sender-Auth: b284eadcf2208b98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 7:11 PM, Eric Sesterhenn <snakebyte@gmx.de> wrote:
>> I am currently trying to reproduce this with SLAB as Vegard
>> suggested for the kmemcheck report. After this I'll retest this
>> on a fresh tree to make sure it isnt something buggy on my part
>> and try some older kernels.
>
> ok, with CONFIG_SECURITY, SLAB and CONFIG_DEBUG_SLAB on the
> -rc3 based kmemcheck tree enabled i dont get any error.
> I am currently building a fresh -rc4 (with SLUB) to make
> sure this is for real, then i'll try that again with SLAB
> and then start testing older kernels.

Then it's likely that we corrupt hugetlbfs_inode_cachep because of
SLUB merging and the real problem is somewhere else. Can you also try
passing 'slub_nomerge" as a kernel parameter with SLUB?
