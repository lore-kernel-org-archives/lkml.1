Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbZAODXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbZAODXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 22:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbZAODW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 22:22:59 -0500
Received: from ozlabs.org ([203.10.76.45]:34462 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260AbZAODW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 22:22:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: regarding the x86_64 zero-based percpu patches
Date: Thu, 15 Jan 2009 12:19:02 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, travis@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, steiner@sgi.com,
       Hugh Dickins <hugh@veritas.com>
References: <49649814.4040005@kernel.org> <496C071F.3000408@kernel.org> <m1k58zx305.fsf@frodo.ebiederm.org>
In-Reply-To: <m1k58zx305.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151219.03403.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2009 14:37:38 Eric W. Biederman wrote:
> It isn't incompatible with a per-cpu virtual mapping.  It allows the
> possibility of each cpu reusing the same chunk of virtual address
> space for per cpu memory.

This can be done (IA64 does it today), but it's not generically useful.  You can use it to frob a few simple values, but it means you can't store any pointers, and that just doesn't fly in general kernel code.

> I think it would be nice if the percpu area could grow and would not be
> a fixed size at boot time, I'm not particularly convinced it has to.

I used to be convinced it had to grow, but Christoph showed otherwise.  Nonetheless, it's an annoying restriction which is going to bite us in the ass repeatedly as coders use per_cpu on random sizes.

Rusty.
