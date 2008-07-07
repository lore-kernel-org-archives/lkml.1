Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYGGORU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYGGORU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 10:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYGGORF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 10:17:05 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:43256 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbYGGORD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:17:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vNtVbyEi9wHWTT8KKW+948i6eF8UHNvnraNsghjhoLEORUarEiyXNWMEUvnNcCpw7D
         28ZZ500Gx+/+N8epowBY/6JBogOjfZebZifz8GENwyRzELYk0w+uN7PpSdsvlOFurgfT
         a0DifAFjk2RliDdMU9OGlepUFM78kte2sIIko=
Subject: Re: Suggestion: LKM should be able to add system call for itself
From: Josh Boyer <jwboyer@gmail.com>
To: Jinkai Gao <mickeygjk@gmail.com>
Cc: Jan Engelhardt <jengelh@medozas.de>, linux-kernel@vger.kernel.org
In-Reply-To: <fb82a8210807070700u4f191bfaq57df57c293567e4c@mail.gmail.com>
References: <fb82a8210807062209t6cfe3e46m50a11b577f0540e7@mail.gmail.com>
	 <alpine.LNX.1.10.0807071131010.8248@fbirervta.pbzchgretzou.qr>
	 <fb82a8210807070700u4f191bfaq57df57c293567e4c@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 10:16:51 -0400
Message-Id: <1215440211.20774.48.camel@weaponx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-07 at 10:00 -0400, Jinkai Gao wrote:
> On Mon, Jul 7, 2008 at 5:35 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
> >
> > On Monday 2008-07-07 07:09, Jinkai Gao wrote:
> >
> >>LKM(loadable kernel module) was first introduced for drivers. Users
> >>rarely need to talk to the modules directly. If does, several methods
> >>are available now, such as /proc file, interruption, etc. However,
> >>these interfaces are predefined, which makes the communication between
> >>user space and kernel space quite restricted.
> >
> > And that is good -- I certainly do not want something to step out of
> > bounds by accident or intention.
> >
> >>Of course, for driver modules, these mechanisms are enough. But as
> >>long as it is called Loadable Kernel Module instead of Loadable Kernel
> >>Driver, I think it should be able to do more than that. For example,
> >>LSM(linux security module),most of which(selinux, apparmor, etc.) use
> >>policy files as their core. Users write policy files, LSM make access
> >>control decision based on the files. Seems like users don't need to
> >>talk to LSM directly. But what if user want to temporarily disable a
> >>role or capability he is holding ? Not much he can do, isn't
> >>it(although nothing is impossible, making a new system call makes much
> >>more sense).
> >
> > I do not see what a syscall will buy over a "switch file" in procfs or
> > sysfs.
> >
> >>So The LKM should be able to define its own user interface
> >>by adding new system call for itself.
> >
> > And the point is? Why cannot it use, say, a character device?
> 
> Please refer to my reply to Bart.
> 
> >>And actually,  it is not hard to
> >>implement such kind of dynamic system call table as I thought it
> >>through.
> >
> > It is. You do not know what number your syscall will get. And if
> > you knew, it might just happen that this specific number is taken
> > in the next iteration in the Linux kernel.
> 
> You are right. So we can use ascii name instead of number to identify
> the system call. Kernel will match the function with the name.To have
> backward compatibility, number should still be supported. Yes, it is
> not as easy as I thought, but as long as it is valuable and doable, we
> should have a try, right?

So you have to search a list of strings using strcmp to determine what
syscall is being called?  That would be horrible for performance.

josh

