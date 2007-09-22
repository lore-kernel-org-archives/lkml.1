Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbXIVPoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbXIVPoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 11:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXIVPoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 11:44:12 -0400
Received: from gw.goop.org ([64.81.55.164]:49498 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbXIVPoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 11:44:11 -0400
Message-ID: <46F53848.3030100@goop.org>
Date: Sat, 22 Sep 2007 08:44:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v3 1/2] i386/x86_64 boot: setup data
References: <1190192306.12429.76.camel@caritas-dev.intel.com>
In-Reply-To: <1190192306.12429.76.camel@caritas-dev.intel.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> This patch add a field of 64-bit physical pointer to NULL terminated
> single linked list of struct setup_data to real-mode kernel
> header. This is used as a more extensible boot parameters passing
> mechanism.
>
> This patch has been tested against 2.6.23-rc6-mm1 kernel on x86_64. It
> is based on the proposal of Peter Anvin.
>
>
> Known Issues:
>
> 1. Where is safe to place the linked list of setup_data?
> Because the length of the linked list of setup_data is variable, it
> can not be copied into BSS segment of kernel as that of "zero
> page". We must find a safe place for it, where it will not be
> overwritten by kernel during booting up. The i386 kernel will
> overwrite some pages after _end. The x86_64 kernel will overwrite some
> pages from 0x1000 on.
>   

Do you actually need a linked list of data?  This is similar to the
changes to bzImage to support booting bzImage a paravirt environment,
but I just proposed a pointer to a single info structure, along with a
field to identify the boot environment (ie, native/lguest/xen etc).  It
would be easy to extend this to handle EFI as just another boot
environment, and you could hang a list of structures off the pointer.


    J
