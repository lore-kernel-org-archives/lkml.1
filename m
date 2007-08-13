Return-Path: <linux-kernel-owner+w=401wt.eu-S937259AbXHMAX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937259AbXHMAX5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 20:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759821AbXHMAXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 20:23:47 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:49595 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753684AbXHMAXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 20:23:46 -0400
Message-ID: <386964623.18422@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 13 Aug 2007 08:23:42 +0800
From: WU Fengguang <wfg@mail.ustc.edu.cn>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Paul Moore <paul.moore@hp.com>, Stephen Smalley <sds@epoch.ncsc.mil>,
       Chris Vance <cvance@nai.com>, Wayne Salamon <wsalamon@nai.com>,
       James Morris <jmorris@redhat.com>, dgoeddel@trustedcs.com
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070813002342.GA6908@mail.ustc.edu.cn>
Mail-Followup-To: Cyrill Gorcunov <gorcunov@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Paul Moore <paul.moore@hp.com>,
	Stephen Smalley <sds@epoch.ncsc.mil>, Chris Vance <cvance@nai.com>,
	Wayne Salamon <wsalamon@nai.com>, James Morris <jmorris@redhat.com>,
	dgoeddel@trustedcs.com
References: <20070812141905.4ee423b9@the-village.bc.nu> <386927758.14086@ustc.edu.cn> <20070812161744.200d4252@the-village.bc.nu> <20070812162143.GA7202@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812162143.GA7202@cvg>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 08:21:43PM +0400, Cyrill Gorcunov wrote:
> [Alan Cox - Sun, Aug 12, 2007 at 04:17:44PM +0100]
> | Try this (it compiles but isnt tested). Its a weekend here, the sun is
> | shining, the beach is a short walk, and I have more interesting things to
> | do right now 8)
> | 
> | 
[...]
> | -int __vm_enough_memory(long pages, int cap_sys_admin)
> | +int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
> |  {
> |  	unsigned long free, allowed;
> |  
> | @@ -166,7 +166,7 @@
> |  
> |  	/* Don't let a single process grow too big:
> |  	   leave 3% of the size of this process for other processes */
> | -	allowed -= current->mm->total_vm / 32;
> | +	allowed -= mm->total_vm / 32;
> 
> So mm->total_vm is 0 for __bprm_mm_init case. Is that ok? Or I miss
> something?

Yeah, Alan adds mm to the interfaces and leaves us the question of
"what mm to pass in when current->mm == NULL?" ;)

