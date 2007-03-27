Return-Path: <linux-kernel-owner+w=401wt.eu-S934053AbXC0Rcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934053AbXC0Rcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 13:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934054AbXC0Rcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 13:32:51 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:34450 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934053AbXC0Rcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 13:32:50 -0400
Subject: Re: [Patch 3/7] integrity: EVM as an integrity service provider
From: David Safford <safford@watson.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
In-Reply-To: <20070322231917.GC4064@ucw.cz>
References: <1174666176.11149.3.camel@localhost.localdomain>
	 <20070325001605.31ed39e7.akpm@linux-foundation.org>
	 <20070325121321.GA8550@ucw.cz>
	 <1174931715.3493.44.camel@localhost.localdomain>
	 <20070322231917.GC4064@ucw.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Mar 2007 13:32:48 -0400
Message-Id: <1175016768.3533.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 23:19 +0000, Pavel Machek wrote:
> > There are some papers and related userspace code at
> >    http://www.research.ibm.com/gsal/tcpa
> > which describe the architecture in more detail, but basically this 
> > integrity provider is designed to complement mandatory access control
> > systems like selinux and slim. Such systems can protect a running system 
> > against on-line attacks, but do not protect against off-line attacks  
> > (booting Knoppix and changing executables or their selinux labels), or 
> > against attacks which find weaknesses in the kernel or the LSM module 
> > itself.
> 
> Thanks. Can this go to Doc*/ somewhere?

yes, we will add that.
> 
> ...but... If I can attack your system using knoppix, I can get at your
> data, already, right? So you'll need to encrypt your data, anyway? 

no reason to encrypt system files, which are public, and encryption
by itself does not provide the desired integrity - you still end
up having to verify the integrity. 

> 
> > Using a TPM or passphrase, EVM can verify the integrity of all files 
> > (including the kernel and initrd) and their labels before they are 
> 
> How does passphrase work here?

ah, misstated that - the passphrase can be used to HMAC all other files,
but not the kernel and initrd. Only the TPM/BIOS/Loader can do that.

> 
> ...so you have your data encrypted, and you have bootloader that
> verifies kernel/initrd (you need that, anyway). Because you data are
> encrypted, knoppix attack will not work... assuming crypto does some
> integrity checks, but IIRC crypto needs to do that.

most encryption is slower than hmac, and does not provide integrity.
There are some crypto modes (e.g. IAPM) which do both encryption and
integrity, but they are patented, and have overhead above the cost of
just encryption or integrity checking by themselves.
> 
> 							Pavel,

