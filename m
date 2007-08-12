Return-Path: <linux-kernel-owner+w=401wt.eu-S1765273AbXHLOJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765273AbXHLOJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 10:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbXHLOJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 10:09:25 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:43389 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752583AbXHLOJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 10:09:24 -0400
Message-ID: <386927758.14086@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sun, 12 Aug 2007 22:09:17 +0800
From: WU Fengguang <wfg@mail.ustc.edu.cn>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Paul Moore <paul.moore@hp.com>, Stephen Smalley <sds@epoch.ncsc.mil>,
       Chris Vance <cvance@nai.com>, Wayne Salamon <wsalamon@nai.com>,
       James Morris <jmorris@redhat.com>, dgoeddel@trustedcs.com
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070812140917.GA13683@mail.ustc.edu.cn>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Paul Moore <paul.moore@hp.com>,
	Stephen Smalley <sds@epoch.ncsc.mil>, Chris Vance <cvance@nai.com>,
	Wayne Salamon <wsalamon@nai.com>, James Morris <jmorris@redhat.com>,
	dgoeddel@trustedcs.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812141905.4ee423b9@the-village.bc.nu>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 02:19:05PM +0100, Alan Cox wrote:
> > > Great! So the problem might have existed for some time, but we never
> > > saw it due to default over commit values? Were you using these values
> > > for over commit even before?
> > 
> > No I changed it several weeks ago to stop my desktop from freezing.
> > So yes, the bug may have been there for a while.
> 
> The bug is the new exec with lots of arguments code. It tries to insert a
> vm struct without having a valid current->mm. That isn't permitted and
> never had been (which is also why it broke the sparc mmu code etc).
> 
> You'll need to change the kernel security interface a little to make this
> fly - I think the following should do it.
> 
> 	- make __vm_enough_memory take a struct mm pointer and use it
> 	- make security_ops pass the extra current->mm
> 	- add a vm_enough_memory_mm security op
> 	- use security_vm_enough_memory_mm(mm, ...) in __insert_vm_struct
> 
> I'll knock up a quick patch and see what is needed (someone else can do
> the selinux changes)

Thank you!

Count me for one - but CC SELinux maintainers first :)

