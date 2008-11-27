Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbYK0NEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbYK0NEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbYK0NDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:03:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:50047 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYK0NDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:03:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hSWOi0LAQwh80dE6TgtU4Gmd5nqqiSxmgyUHVe27s5FxbyJ1GlvS+iv/763pO6QVdg
         mJp3+IGE/nUAe7Xwv9gxWaocZWLhvMuh0tScHO7gnCol1pnB/RZuM77io4bW0VTmD9o2
         TPyy/y5pV1lKW4+4j8AgFdPuEM80sZkQmMSeE=
Message-ID: <492E9AB2.9030202@gmail.com>
Date: Thu, 27 Nov 2008 15:03:46 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       srostedt@redhat.com, sandmann@daimi.au.dk, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 2/2] tracing: identify which executable object the userspace
 address belongs to
References: <1227353328-16104-1-git-send-email-edwintorok@gmail.com> <1227353328-16104-3-git-send-email-edwintorok@gmail.com> <y0my6z798de.fsf@ton.toronto.redhat.com> <1227782505.4454.1393.camel@twins> <20081127124851.GC23480@redhat.com>
In-Reply-To: <20081127124851.GC23480@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-27 14:48, Frank Ch. Eigler wrote:
> Hi -
>
> On Thu, Nov 27, 2008 at 11:41:45AM +0100, Peter Zijlstra wrote:
>   
>>>> Impact: modify+improve the userstacktrace tracing visualization feature
>>>> [...]
>>>> You'll see stack entries like:
>>>>    /lib/libpthread-2.7.so[+0xd370]
>>>> [...]
>>>>         
>>> Can you suggest an actual distribution & architecture where this
>>> facility may be tested/used?  It appears to require frame-pointer
>>> stuff that AFAIK is not generally turned on for user-space.
>>>       
>> gentoo, just rebuild world with frame pointers ;-)
>>     
>
> Well, that only goes so far.  If this feature turns out unable to work
> without distributors recompiling all their stuff on, for example, x86-64,
> then expectations need to be reset.

My assumption is that this feature will be used to trace individual
applications, and not the system as a whole.
Then you only need libc to be recompiled with frame pointers on, and
your own application/your own application's libraries.

That is what I want to use it for, and there isn't another solution that
allows me to do this.
Sure I can trace userspace alone using ptrace (which has its own
overhead), and the kernel alone by using ftrace, but I can't combine
those traces in a meaningful manner.
If/when the kernel will support dwarf unwinding, it will only need to
provide an alternate implementation for save_stack_trace_user.

Even without frame pointers you can at least get the return address to
userspace, which may be inside your application for page faults.

If I need to do system-wide tracing, I can use my 32-bit chroot [*], or
boot my laptop which is 32-bit.

I don't think that this feature should get rejected just because it is
not easily usable from x86_64.

[*] I haven't tested yet if tracing 32-bit applications from a 64-bit
kernel works. It probably won't, and I'll need to use a different struct
stack_frame with 32-bit addresses.

Another approach I've though of would be to deliver a signal to
userspace on demand, and have the signal handler do the backtrace, but
that would unnecesary overhead.

Best regards,
--Edwin
