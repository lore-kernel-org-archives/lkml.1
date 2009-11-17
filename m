Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294AbZKQRmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbZKQRmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZKQRmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:42:05 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:52466 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbZKQRmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:42:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kZb1LbxFEeQAPqe4E0sH77mmxDN6nud5nH4uAfilGCD5Ctze0j1IeIHx5UsKjIe+j1
         3ZH3SKC2clbwQY9EbXg5RURLaaqOOgoD82JodFXqmH/kdvlvrBgU3M7esumu7+USmCJR
         HvF2Aci1Wc9rJcKk45aiA8NvNJcXRVwohrv5s=
Date: Tue, 17 Nov 2009 20:42:04 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: hpa@zytor.com, mingo@elte.hu, travis@sgi.com, tglx@linutronix.de,
       akpm@linux-foundation.org, heiko.carstens@de.ibm.com, rdreier@cisco.com,
       rdunlap@xenotime.net, tj@kernel.org, andi@firstfloor.org,
       gregkh@suse.de, yhlu.kernel@gmail.com, rientjes@google.com,
       rostedt@goodmis.org, rusty@rustcorp.com.au,
       seto.hidetoshi@jp.fujitsu.com, steiner@sgi.com, fweisbec@gmail.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] INIT: Limit the number of per cpu calibration
	bootup messages
Message-ID: <20091117174204.GD5476@lenovo>
References: <20091116215052.GK5653@lenovo> <20091116.190922.182816918.davem@davemloft.net> <20091117155946.GA5476@lenovo> <20091117.082928.10537098.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117.082928.10537098.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 08:29:28AM -0800, David Miller wrote:
> From: Cyrill Gorcunov <gorcunov@gmail.com>
> Date: Tue, 17 Nov 2009 18:59:46 +0300
> 
> > Perhaps for other archs like SPARC64, where as you said no need to
> > remember boot cpu id at all, we should define some __weak per-kernel
> > global helper which would return 0 and every arch would implement
> > own helper boot_cpu_id().
> 
> On many of my machines none of my cpus are numbered "0", so that
> wouldn't be a legitimate implementation on sparc64.
> 
> I see no reason for a platform the be required to remember the boot
> cpu ID, there is nothing special about that processor generically.

I fear we still need it and it's special due to code structure at
least. For SMP compiled kernel say callin() do change its behaviour
depending on which cpu it's called.

Also iy seems a differ techhique used to find out on which cpu
the code is running: there is smp_processor_id() == 0 and raw version
and boot_cpu_id and cpu == 0, so having one general boot_cpu_id() would
be more clear (though we will need to clean code up then :)

So plain hard_smp_processor_id() wouldn't help since it doesn't
say if this is a boot cpu or not.

> 
> And if we do need it generically, it's available there as
> hard_smp_processor_id() when start_kernel() is called.  So init/main.c
> could remember that value in an __initdata annotated static variable.
> 
> But just using a boolean for this "did I print the bogomips message
> already?" thing seems more than sufficient.
> 

Yes. As I see Mike already pick it up. Thanks David!

	-- Cyrill
