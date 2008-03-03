Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYCCMiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYCCMiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYCCMiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:38:10 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:54061 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbYCCMiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:38:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=qqCQtCF4ByT7wuU7Z7RgYHJOYnvsHRvmNVmyQBl0sxFTYpmyEyAPf57+5C8pzBaPWGpSy8c6zEwAYnkYVUmWW6HUR8D0YtcBzqTLbfKvhtsqGa1uFcKDIksr7kdLCMAAoK+duqAb7I23ZzLyU182hZ3gHQ8rCwRr2MQ7i705eww=
Message-ID: <47CBF12C.2070506@gmail.com>
Date: Mon, 03 Mar 2008 13:38:04 +0100
From: Jiri Olsa <olsajiri@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nadia Derbey <Nadia.Derbey@bull.net>, peifferp@gmail.com
Subject: Re: [BUG] soft lockup detected with ipcs
References: <47C7E280.4010805@gmail.com> <Pine.LNX.4.64.0802291241080.7699@twin.jikos.cz> <47CAE7D5.5040907@gmail.com> <20080302120236.61e0ec74.akpm@linux-foundation.org> <Pine.LNX.4.64.0803022214190.15209@jikos.suse.cz> <Pine.LNX.4.64.0803022223360.15209@jikos.suse.cz> <47CBE871.4090309@gmail.com> <Pine.LNX.4.64.0803031305090.15209@jikos.suse.cz> <47CBECB8.7040605@gmail.com> <Pine.LNX.4.64.0803031324200.15209@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0803031324200.15209@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Mon, 3 Mar 2008, Jiri Olsa wrote:
> 
>> ipcs.kernel.out.1 is the kernel log from the time strace ipcs was done.
>> ipcs.kernel.out.2 is from the next run of ipcs that stuck,
>> there's no overlay between those logs.
>> When the kernel freeze I'm getting logs with the spinlock lockup.. and it's repeating.
> 
> Thanks. Have you tried turning lockdep off, if that still triggers?
> 
> Aparently the first BUG leaves the spin lock locked, and all subsequent 
> accessess to it lock the machine hard. We'll need to see what goes wrong 
> inside lockdep.
> 
> Could you please run
> 
> 	addr2line -e vmlinux c0133034
> 
> (passing the path to the vmlinux binary of the crashing kernel to the -e 
> parameter).
> 

I've rebuilt the kernel meanwhile, so dont know how accurate this output is:

/home/jirka/xxx/kernel/linux-2.6-stable/include/asm/atomic_32.h:97

Anyway, I'll run the test again with your patch, and then we can run the addrline again...
I'll try to turn the lockdep off as well.
