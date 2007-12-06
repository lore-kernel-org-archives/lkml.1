Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbXLFUwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbXLFUwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbXLFUwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:52:00 -0500
Received: from ns2.suse.de ([195.135.220.15]:56560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbXLFUv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:51:59 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: 2.6.23: x86_64 oops caused by hotplug running before vdso initialized
Date: Thu, 6 Dec 2007 21:51:55 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <4758512E.1060306@redhat.com>
In-Reply-To: <4758512E.1060306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712062151.55480.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2007 20:44:46 Chuck Ebbert wrote:
> pages is NULL here, implying vma->vm_private_data was NULL. This is apparently
> because init_vdso_vars() is __initcall and runs after the rootfs gets populated.
> An experimental initrd containing an /sbin/hotplug binary caused this. Normally
> we don't have that file in the initrd. Should vdso init be done earlier to prevent
> this problem?

We've often had bugs like this. Sure it could be fixed here, but then
the next bug would crop up again later I bet.

It would be better to move the first user  space code execution later I think. 
I guess the hotplug events could be delayed or initrd just mounted later.

Running any user space before __initcall() has finished is just wrong.

-Andi
