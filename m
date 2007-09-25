Return-Path: <linux-kernel-owner+w=401wt.eu-S1757694AbXIYP1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbXIYP1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbXIYP1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:27:05 -0400
Received: from styx.suse.cz ([82.119.242.94]:56980 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756839AbXIYP1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:27:03 -0400
Date: Tue, 25 Sep 2007 17:23:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Franck Bui-Huu <vagabon.xyz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm1 -- powerpc link failure
In-Reply-To: <20070925134653.GB8447@shadowen.org>
Message-ID: <Pine.LNX.4.64.0709251715530.7567@jikos.suse.cz>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
 <20070925134653.GB8447@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007, Andy Whitcroft wrote:

> As suggested elsewhere I have had a go at tracking this down.  Previous 
> problems of this kind were introduced as a result of using 'weak' 
> declarations to provide default implementations.  This investigation led 
> me to the following commit:
>   commit c60473b5d32ea6cf4561232bc852bacd3a513528
>   Author: Jiri Kosina <jkosina@suse.cz>
>   Date:   Sat Sep 15 01:49:49 2007 +0000
>     i386-and-x86_64-randomize-brk
> Backing this change out seems to get us past this problem.  If we are to 
> support compilers of this age, and I believe we currently do, then we 
> probabally need to avoid the weak declarations and use the Kconfig 
> system to provide the alternatives here.
> Jiri?

Hi,

actually, my first patch wasn't using weak symbols, but I have been 
convinced that it's the way to go(tm). Please see 
http://lkml.org/lkml/2007/9/1/131 and the ongoing thread.

I am fine with replacing the brk randomization patch with the one that 
wasn't using weak symbols (posted in the mentioned thread too), I have no 
strong opinion either way.

Thanks,

-- 
Jiri Kosina
SUSE Labs
