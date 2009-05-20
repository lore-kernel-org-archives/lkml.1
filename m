Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZETQN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZETQN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 12:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbZETQNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 12:13:52 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:48526 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZETQNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 12:13:51 -0400
Message-ID: <4A142CC9.4050904@oracle.com>
Date: Wed, 20 May 2009 09:16:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       borislav.petkov@amd.com, dougthompson@xmission.com
Subject: Re: linux-next: Tree for May 20 (amd64_edac)
References: <20090520170807.b75a9d86.sfr@canb.auug.org.au>
In-Reply-To: <20090520170807.b75a9d86.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4A142C37.005A:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090519:
> 
> Undropped tree:
> 	edac-amd
> 
> The edac-amd tree lost its build failure.


When K8_NB is not enabled:

drivers/built-in.o: In function `amd64_edac_init':
amd64_edac.c:(.init.text+0x254f6): undefined reference to `cache_k8_northbridges'
amd64_edac.c:(.init.text+0x25c38): undefined reference to `num_k8_northbridges'


Error with EDAC_AMD64 =y or =m.
Error on both i386 and on x86_64.


Comments on Kconfig for EDAC_AMD64:

config EDAC_AMD64
	tristate "AMD64 (Opteron, Athlon64) K8, F10h, F11h"
	depends on EDAC_MM_EDAC && X86 && PCI
	default m
	help
	Support for error detection and correction on the AMD 64
	Families of Memory Controllers (K8, F10h and F11h)


Does this actually apply to X86_32 or should the depends be on
X86_64 instead of X86?

The default y on EDAC_MM_EDAC and default m on EDAC_AMD64 should
be removed.

The 2 lines of help text should be indented by 2 spaces.

Would be Good to have the amd64_edac maintainer(s) email addresses
in MAINTAINERS file, please.

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
