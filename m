Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbYADAHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbYADAHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 19:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYADAHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 19:07:33 -0500
Received: from ns2.suse.de ([195.135.220.15]:44532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbYADAHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 19:07:32 -0500
Message-ID: <477D78BE.1060404@suse.de>
Date: Fri, 04 Jan 2008 09:07:26 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
       bjorn.helgaas@hp.com
Subject: Re: Error returns not handled	correctly	by	sysfs.c:subsys_attr_store()
References: <1195683419.16019.225.camel@grinch>	 <20071126203116.0c93cdb9.akpm@linux-foundation.org>	 <20071127053321.GA975@kroah.com>  <474D1BD4.2050805@suse.de>	 <1196278300.5431.9.camel@grinch>  <474E10CF.7050009@suse.de>	 <1196716558.20124.179.camel@bluto.andrew> <1199404273.7025.21.camel@bluto.andrew>
In-Reply-To: <1199404273.7025.21.camel@bluto.andrew>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrew Patterson wrote:
> It looks like this is a shell issue.  After looking through the sysfs
> code, I realized that this problem seems to be driven from user-land.
> So I performed some experiments:
> 
>      1. Wrote a simple program that just used write(2) to write to the
>         sysfs entry. This works fine.
>      2. Used /bin/echo instead of the built-in echo command.  This too
>         works fine.
>      3. Tried several shells.  Zsh and Bash both fail.  Csh works fine.
> 
> I then ran strace on the following shell-script:
> 
> #!/bin/bash
> 
> echo x > allow_restart
> echo y > allow_restart
> echo z > allow_restart
> 
> and got:
> 
> # strace -e trace=write ~/tmp/tester.sh 
> write(1, "x\n", 2)                      = -1 EINVAL (Invalid argument)
> write(1, "x\n", 2)                      = -1 EINVAL (Invalid argument)
> write(2, "/home/andrew/tmp/tester.sh: line"..., 72/home/andrew/tmp/tester.sh: line 4: echo: write error: Invalid argument
> ) = 72
> write(1, "x\ny\n", 4)                   = -1 EINVAL (Invalid argument)
> write(1, "x\ny\n", 4)                   = -1 EINVAL (Invalid argument)
> write(2, "/home/andrew/tmp/tester.sh: line"..., 72/home/andrew/tmp/tester.sh: line 5: echo: write error: Invalid argument
> ) = 72
> write(1, "x\ny\nz\n", 6)                = -1 EINVAL (Invalid argument)
> write(1, "x\ny\nz\n", 6)                = -1 EINVAL (Invalid argument)
> write(2, "/home/andrew/tmp/tester.sh: line"..., 72/home/andrew/tmp/tester.sh: line 6: echo: write error: Invalid argument
> ) = 72
> write(1, "x\ny\nz\n", 6x
> y
> z
> )                = 6
> Process 3800 detached

Eeeeeeeekkkk.... That's scary.  Which distro are you using and what does
'bash --version' say?

-- 
tejun
