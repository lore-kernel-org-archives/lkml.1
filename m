Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbYIXXub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbYIXXub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 19:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbYIXXuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 19:50:22 -0400
Received: from sous-sol.org ([216.99.217.87]:50032 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752346AbYIXXuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 19:50:22 -0400
Date: Wed, 24 Sep 2008 16:49:03 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       James Morris <jmorris@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       Andreas Gruenbacher <agruen@suse.de>, Andrew Morton <akpm@osdl.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 2/2] file capabilities: remove
	CONFIG_SECURITY_FILE_CAPABILITIES
Message-ID: <20080924234857.GA22375@sequoia.sous-sol.org>
References: <20080924020432.GA25997@us.ibm.com> <20080924020526.GA26058@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924020526.GA26058@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Serge E. Hallyn (serue@us.ibm.com) wrote:
> Remove the option to compile the kernel without file capabilities.  Not
> compiling file capabilities actually makes the kernel less safe, as it
> includes the possibility for a task changing another task's capabilities.
> 
> Some are concerned that userspace tools (and user education) are not
> up to the task of properly configuring file capabilities on a system.
> For those cases, there is now the ability to boot with the no_file_caps
> boot option.  This will prevent file capabilities from being used in
> the capabilities recalculation at exec, but will not change the rest
> of the kernel behavior which used to be switchable using the
> CONFIG_SECURITY_FILE_CAPABILITIES option.

(note: defconfig has CONFIG_SECURITY_FILE_CAPABILITIES=y)
   text    data     bss     dec     hex filename
6805157 1018344  671900 8495401  81a129 obj64-defconfig/vmlinux
6805151 1018368  671900 8495419  81a13b obj64-defconfig-patch1/vmlinux
6805151 1018368  671900 8495419  81a13b obj64-defconfig-patch2/vmlinux
6804605 1018344  671900 8494849  819f01 obj64-nofcap/vmlinux
6804604 1018344  671900 8494848  819f00 obj64-nofcap-patch1/vmlinux
6805150 1018368  671900 8495418  81a13a obj64-nofcap-patch2/vmlinux

The last 2 show the real diff now, add 570 bytes by effectively forcing
CONFIG_SECURITY_FILE_CAPABILITIES on.

What is being done to enable userspace in distros to make those 570
bytes generally useful?

thanks,
-chris
