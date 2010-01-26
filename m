Return-Path: <linux-kernel-owner+w=401wt.eu-S1751759Ab0AZAZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab0AZAZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214Ab0AZAZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:25:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:35801 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab0AZAZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:25:37 -0500
Message-ID: <4B5E37BD.5020400@kernel.org>
Date: Tue, 26 Jan 2010 09:30:53 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, ebiederm@xmission.com, tytso@mit.edu,
       Trond.Myklebust@netapp.com, aelder@sgi.com, hch@infradead.org,
       davem@davemloft.net, netdev@vger.kernel.org, x86@kernel.org,
       mingo@redhat.com, fweisbec@gmail.com, dan.j.williams@intel.com,
       borislav.petkov@amd.com, ying.huang@intel.com, lenb@kernel.org,
       neilb@suse.de, cl@linux-foundation.org
Subject: Re: [PATCHSET] percpu: add __percpu sparse annotations
References: <1264432935-10453-1-git-send-email-tj@kernel.org> <20100125231411.GA19799@ZenIV.linux.org.uk>
In-Reply-To: <20100125231411.GA19799@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Jan 2010 00:24:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/26/2010 08:14 AM, Al Viro wrote:
> Um.  Where *is* the definition of __percpu?  Presumably, that'd be
> something like __attribute__((noderef,address_space(4)) under ifdef
> __CHECKER__ and empty otherwise?  If so, I'm fine with that patchset,
> provided that it does grow that #define and becomes self-contained...

Ah... sorry, I forgot about the base tree.  The definition has been in
the percpu tree for some time now.  The patchset is on top of the
following branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-next

and the series is available as git tree in the following branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git percpu-sparse-review

The definition is in include/linux/compiler.h.

# define __percpu	__attribute__((noderef, address_space(3)))

which gets replaced by dummy def if !__CHECKER__.

Thanks.

-- 
tejun
