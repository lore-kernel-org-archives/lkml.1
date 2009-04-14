Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbZDNJDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbZDNJDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZDNJDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:03:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:54650 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbZDNJDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:03:40 -0400
Message-ID: <49E450EE.9010502@kernel.org>
Date: Tue, 14 Apr 2009 18:01:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Mike Travis <travis@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH] unbreak alpha percpu
References: <20090410151224.GM26366@ZenIV.linux.org.uk>	<20090410154704.GN26366@ZenIV.linux.org.uk>	<alpine.LFD.2.00.0904100915010.4583@localhost.localdomain> <20090414094556.3af71358@skybase>
In-Reply-To: <20090414094556.3af71358@skybase>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 09:01:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Martin.

Martin Schwidefsky wrote:
> I would like to get rid of that SHIFT_PERCPU_PTR mess. The patch from
> Ivan will allow this, it uses a dummy variable to void the effect of a
> static modifier for percpu variables in modules. The percpu variable
> itself will be defined non-static, my gut feeling is that this is a
> dirty little trick that might bite us in the future.
> Another solution which I personally would prefer is to ban the use of
> static percpu variables. Then the compiler will use the GOT to get the
> address of percpu variables without any dirty tricks.

Hmmm... even if we can make combination of DECLARE_PER_CPU() and
static DEFINE_PER_CPU() trigger compile error?  That pretty much
implements most of what the programmer intends by "static" but yeah
it's a bit convoluted.

Thanks.

-- 
tejun
