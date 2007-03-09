Return-Path: <linux-kernel-owner+w=401wt.eu-S1767399AbXCIQxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767399AbXCIQxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767402AbXCIQxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:53:41 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:50318 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767399AbXCIQxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:53:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H4m1jeoYskOIdE/gyJecpRPLh2xIAUPQjBe0XLin59sMDiT5epAo40LZPZOgQQYBFGzvYOFzv3LR/DM/D3EVXZSAey2IF1yw8pi5Kbt7xR7SPC1Kzl5ICb6kssgpkRQ3tWxbe6s/fE24/gOMDbOfyGQJgxH8sWTAmatpRo05OR0=
Message-ID: <b0943d9e0703090853i6deb0581wec7e962d0d76b9df@mail.gmail.com>
Date: Fri, 9 Mar 2007 16:53:39 +0000
From: "Catalin Marinas" <catalin.marinas@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Possible "struct pid" leak from tty_io.c
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <m1y7m64cpw.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b0943d9e0703080927hde01f7dt9ae06433e0c87549@mail.gmail.com>
	 <m13b4f7ggy.fsf@ebiederm.dsl.xmission.com>
	 <b0943d9e0703090253r690e1f21qf8d7a1edfd08561b@mail.gmail.com>
	 <m1y7m64cpw.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Catalin Marinas" <catalin.marinas@gmail.com> writes:
>
> > On 08/03/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> "Catalin Marinas" <catalin.marinas@gmail.com> writes:
> >
> > I think it's only the pid_chain and rcu member that could be placed in
> > a list and kmemleak scans the memory for these two offsets as well.
> > I'll check those lists anyway but I doubt it's a more fundamental
> > problem with how kmemleak handles struct pid as I should've probably
> > got more reports.
>
> Right.  I was pointing out the possibilities but because we do
> some tricky things.  Mostly I was wondering about the hlist for
> the list of tasks.  Now if a task is on that list we should have
> a struct pid_link pointing at our struct pid, so it shouldn't fool
> kmemleak but I'm still a little curious if all of those hlist_heads are
> NULL pointers.

Yes, all the 3 hlist_head tasks are NULL pointers on the reported object.

-- 
Catalin
