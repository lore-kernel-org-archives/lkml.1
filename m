Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZKQP7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZKQP7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbZKQP7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:59:46 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:60766 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbZKQP7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:59:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c19hEsXcx3SRv4xeYhfPMESfZVSsp+SOLJjvTrEfOx/64L7d5isqJq7AjXe6Nu0aTq
         zCq31Eh1SOvm2WJRpPS1LxBJEYnXFmm8A57ZA2NxP3FwEqdHKjL3tecSfeEofHrAzx5g
         KSlCjTNbB6iI68aA9yMxb9tgvlTYP9XYduIfk=
Date: Tue, 17 Nov 2009 18:59:46 +0300
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
Message-ID: <20091117155946.GA5476@lenovo>
References: <20091116214302.GJ5653@lenovo> <4B01C81F.9040000@zytor.com> <20091116215052.GK5653@lenovo> <20091116.190922.182816918.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091116.190922.182816918.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 07:09:22PM -0800, David Miller wrote:
...
> >
> > IA-64 and SPARC already has this variable. But boot_cpu_id() as an
> > inline function seem to be more natural/portable ineed.
> 
> Only 32-bit SPARC actually has it.  On sparc64 we have no reason to
> remember which processor was the boot cpu, and remembering it merely
> for the sake of only printing out the bogomips message once seems a
> bit excessive?
> 
> How about:
> 
> 	static bool printed;
> 
> 	if (!printed) {
> 		printk(...);
> 		printed = true;
> 	}
> 
> Or, alternatively, use an atomic_t instead of a bool if you think
> races matter this early in the boot process.
> 

Hi David,

I must admit I know *nothing* about SPARC code. I was rather pointing
out that some archs already use this variable.  IOW it means
that per-platform boot_cpu_id() helper implementation may be not
that simple. Perhaps for other archs like SPARC64, where as you
said no need to remember boot cpu id at all, we should define
some __weak per-kernel global helper which would return 0
and every arch would implement own helper boot_cpu_id().

	-- Cyrill
