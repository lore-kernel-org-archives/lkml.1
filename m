Return-Path: <linux-kernel-owner+w=401wt.eu-S932731AbZJHQgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731AbZJHQgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758737AbZJHQgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:36:40 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41709 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608AbZJHQgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:36:39 -0400
Subject: Re: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Byron Stanoszek <bstanoszek@comtime.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <b6a2187b0910080926x303d3c9em8f70632fb19b6509@mail.gmail.com>
References: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com>
	 <alpine.LFD.2.01.0910051110200.3432@localhost.localdomain>
	 <b6a2187b0910051715y4ee63503y148ba2d7e24cad8e@mail.gmail.com>
	 <alpine.LFD.2.01.0910051727420.3432@localhost.localdomain>
	 <b6a2187b0910052312o662642b2teded3d19548b9151@mail.gmail.com>
	 <alpine.LFD.2.01.0910060731190.3432@localhost.localdomain>
	 <b6a2187b0910080926x303d3c9em8f70632fb19b6509@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 08 Oct 2009 09:35:48 -0700
Message-Id: <1255019748.9915.1389.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 00:26 +0800, Jeff Chua wrote:
> Newly compiled 64-bit kernel hangs on a previously working pure 32-bit
> 2.6.32-rc3 system ...
> 
> VFS: Mounted root (reiserfs filesystem) readonly on device 8:2.
> Freeing unused kernel memory: 444k freed
> request_module: runaway loop modprove binfmt-464c
> request_module: runaway loop modprove binfmt-464c
> request_module: runaway loop modprove binfmt-464c
> request_module: runaway loop modprove binfmt-464c
> request_module: runaway loop modprove binfmt-464c

Take a quick look in your .config in the "Executable file formats /
Emulations" section.  Make sure that you have ia32 emulation enabled:

CONFIG_IA32_EMULATION=y

That might not have been turned on if you used a .config from an old
32-bit kernel.  

-- Dave

