Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbXLFVKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbXLFVKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 16:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbXLFVKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 16:10:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbXLFVKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 16:10:47 -0500
Message-ID: <47586554.5090409@redhat.com>
Date: Thu, 06 Dec 2007 16:10:44 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23: x86_64 oops caused by hotplug running before vdso initialized
References: <4758512E.1060306@redhat.com> <200712062151.55480.ak@suse.de>
In-Reply-To: <200712062151.55480.ak@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2007 03:51 PM, Andi Kleen wrote:
> On Thursday 06 December 2007 20:44:46 Chuck Ebbert wrote:
>> pages is NULL here, implying vma->vm_private_data was NULL. This is apparently
>> because init_vdso_vars() is __initcall and runs after the rootfs gets populated.
>> An experimental initrd containing an /sbin/hotplug binary caused this. Normally
>> we don't have that file in the initrd. Should vdso init be done earlier to prevent
>> this problem?
> 
> We've often had bugs like this. Sure it could be fixed here, but then
> the next bug would crop up again later I bet.
> 
> It would be better to move the first user  space code execution later I think. 
> I guess the hotplug events could be delayed or initrd just mounted later.

It was suggested that I just make the uevent_helper an empty string,
since that's what our (Fedora) initrd does anyway when it starts.
 
> Running any user space before __initcall() has finished is just wrong.

I thought that was a feature, so some early userspace code could help bring
up devices.
