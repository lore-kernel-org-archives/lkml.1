Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbYHUFR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbYHUFR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 01:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYHUFRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 01:17:19 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:41988 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbYHUFRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 01:17:18 -0400
Message-ID: <48ACF9E8.6020203@cs.columbia.edu>
Date: Thu, 21 Aug 2008 01:15:20 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: dave@linux.vnet.ibm.com
CC: arnd@arndb.de, jeremy@goop.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [RFC v2][PATCH 1/9] kernel based checkpoint-restart
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>
In-Reply-To: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject line should have been 's/PATCH 1/PATCH 0/' ...

I left cr_debug() in for now to provide more info than pr_debug();
eventually that will be changed back to pr_debug()

In the mini-conference we considered doing CR in a kernel module,
but decided against because we needed a system call. It is still
possible to put the bulk of the code in a module. This is useful,
besides reducing debug time (recompile, unload, reload), to reduce
the kernel memory footprint. Also, an administrator can load/unload
the module to enable/disable this feature. Any thoughts ?

Oren.

Oren Laadan wrote:
> 
> These patches implement checkpoint-restart [CR v2]. This version adds
> save and restore of open files state (regular files and directories)
> which makes it more usable. Other changes address the feedback given
> for the previous version. It is also refactored (along Dave's posting)
> for easier reviewing.
> 
> Todo:
> - Add support for x86-64 and improve ABI
> - Refine or change syscall interface
> - Extend to handle (multiple) tasks in a container
> - Security (without CAPS_SYS_ADMIN files restore may fail)
> 
> Changelog:
> 
> [2008-Aug-20] v2:
>   - Added dump and restore of open files (regular and directories);
>     see the changes in the test program (ckpt.c)
>   - Added basic handling of shared objects, and use 'parent tag'
>   - Added documentation
>   - Improved ABI, add 64bit padding for image data
>   - Improved locking when saving/restoring memory
>   - Added UTS information to header (release, version, machine)
>   - Cleanup extraction of filename from a file pointer
>   - Refactor to allow easier reviewing
>   - Remove requirement for CAPS_SYS_ADMIN until we come up with a
>     security policy (this means that file restore may fail)
>   - Other cleanup in response to comments for v1
> 
> [2008-Jul-29] v1:
>   - Initial version: support a single task with address space of only
>     private anonymous or file-mapped VMAs; syscalls ignore pid/crid
>     argument and act on current process.
> 

