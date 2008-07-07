Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbYGGMhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbYGGMhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 08:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbYGGMhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 08:37:04 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:49519 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbYGGMhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:37:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KdZE3SBBbYcySLPgyqUCyU9LUA2UJbAo55bzDt/uTnl6/yjeQtD9/RDnBlwhUY+8DT
         hCaOLH7zFkjxSuhgb3HNBinNpem+Cw2/hWbIqGRVj4tz1ZJxDkFXtn06ekZ8ygkHFhon
         Ik6kwYPB/80ZPHHhjAvGJfooHpY4BLxFjlfKM=
Message-ID: <fb82a8210807070536o3e6a1ed8ld05505b0d80112f3@mail.gmail.com>
Date: Mon, 7 Jul 2008 08:36:58 -0400
From: "Jinkai Gao" <mickeygjk@gmail.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Suggestion: LKM should be able to add system call for itself
Cc: linux-kernel@vger.kernel.org, "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <e2e108260807070140l3f8eaf06w7ee7e8a4ae42f2c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fb82a8210807062209t6cfe3e46m50a11b577f0540e7@mail.gmail.com>
	 <e2e108260807070140l3f8eaf06w7ee7e8a4ae42f2c2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2008 at 4:40 AM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> On Mon, Jul 7, 2008 at 7:09 AM, Jinkai Gao <mickeygjk@gmail.com> wrote:
>> LKM(loadable kernel module) was first introduced for drivers. Users
>> rarely need to talk to the modules directly. If does, several methods
>> are available now, such as /proc file, interruption, etc. However,
>> these interfaces are predefined, which makes the communication between
>> user space and kernel space quite restricted.
>
> Did you already have a look at e.g. http://lwn.net/Kernel/LDD3/ for
> suggestions of alternatives for communication between userspace and
> kernel modules ? Alternatives to system calls are e.g. ioctl's, memory
> mapped I/O and sockets.

Yes, all kinds of alternatives exist. But they are alternatives
anyway, which are tricky ways to do things when you can't find a
reasonable ways. Actually,to communication between userspace and
kernel modules, all I need is a interface with two parameters, all the
system calls can be implemented out of that. So basically you can
write every system call using something like ioctl. But ioctl is not
designed for generic purpose after all.

Why the number of system calls is growing? because the kernel is
growing. why we don't use the alternatives to implement the new need
for system calls? Because it doesn't make any sense. We can't ignore
the kernel modules' need for system calls just because they are
loadable.
