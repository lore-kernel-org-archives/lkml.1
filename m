Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbZBTACI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbZBTACI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 19:02:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbZBTABz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 19:01:55 -0500
Received: from main.gmane.org ([80.91.229.2]:41144 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669AbZBTABx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 19:01:53 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Thomas Backlund <tmb@mandriva.org>
Subject: Re: [patch 03/36] Fix Intel IOMMU write-buffer flushing
Date: Fri, 20 Feb 2009 01:59:48 +0200
Message-ID: <499DF274.8040702@mandriva.org>
References: <20090218222447.432108614@mini.kroah.org> <20090218222901.GD10668@kroah.com> <499C9394.5030704@mandriva.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Woodhouse <David.Woodhouse@intel.com>
X-Gmane-NNTP-Posting-Host: ndn243.bob.fi
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
In-Reply-To: <499C9394.5030704@mandriva.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Backlund skrev:
> This patch is broken compared to what's in:
> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ca77fde8e62cecb2c0769052228d15b901367af8 
> 
> 
> attached patch fixes it
> 

As no-one responded yet...

I forgot to tell how to reproduce it:

on x86_64:

make defconfig
make

and you will end up with:
[thomas@tmb linux-2.6.27.19-rc1]$ LC_ALL=C make
   CHK     include/linux/version.h
   CHK     include/linux/utsrelease.h
   CALL    scripts/checksyscalls.sh
   CHK     include/linux/compile.h
   CC      drivers/pci/intel-iommu.o
drivers/pci/intel-iommu.c: In function 'iommu_flush_write_buffer':
drivers/pci/intel-iommu.c:530: error: 'rwbf_quirk' undeclared (first use 
in this function)
drivers/pci/intel-iommu.c:530: error: (Each undeclared identifier is 
reported only once
drivers/pci/intel-iommu.c:530: error: for each function it appears in.)
make[2]: *** [drivers/pci/intel-iommu.o] Error 1
make[1]: *** [drivers/pci] Error 2
make: *** [drivers] Error 2
[thomas@tmb linux-2.6.27.19-rc1]$

This happends because 'rwbf_quirk' is declared after it's first use.

The upstream git has 'rwbf_quirk' declared before any use of it.

That's what my patch fixes, by simply moving

static int rwbf_quirk = 0;

to the beginning of the file...

Hopefully this helps.
--
Thomas


