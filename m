Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbXEQJPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbXEQJPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 05:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbXEQJPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 05:15:34 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:62547 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbXEQJPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 05:15:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=SaHEpOgn+UFQXXgXxAk+S5QBOJc2//EfQ8UnRJGSBCvOtWZwwuJ+9DC5IUA7HP5pf3x2+b7IUvjPqdSpfpPIrgf7crpGanp6gXuKs3yoOVAUs1BbeC67INsaPAJ//gDSZ5o0/HuM+GHc/GI/1KKCOjMXAvwYZhDbFYzVojxSPSo=
Message-ID: <464C1D11.8040305@gmail.com>
Date: Thu, 17 May 2007 11:14:57 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Dave Jones <davej@redhat.com>, Francesco Pretto <ceztko@gmail.com>,
       Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no> <200705160129.16048.rob@landley.net> <464AEDD0.3090304@gmail.com> <200705161948.56497.rob@landley.net>
In-Reply-To: <200705161948.56497.rob@landley.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
>> Yeap, definitely a bug in the kernel and we're trying to fix it.  Just
>> for the record, we have _always_ issued FLUSH CACHE, so there hasn't
>> been and won't be any data loss problem.  The data loss problem was
>> mentioned as why we can't do things completely inside kernel without
>> updating userland shutdown(8) which issues STANDBYNOW.
> 
> Ok, so the change is to get shutdown to _stop_ doing something stupid 
> (spinning down the disk without first flushing the cache), and the correct 
> thing for shutdown to do is keep its' mitts off the thing and let the kernel 
> power down the darn hardware?

Yeah, about right.  Because kernel can't skip FLUSH CACHE and FLUSH
CACHE can spin up the disk back again.  Oh well, some disks even spin
back up on STANDBYNOW to spin down again.  The big fat warning and all
compat mess are to avoid introducing regression and urge shutdown(8)
update such that it does nothing.

-- 
tejun
