Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbYKYPqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbYKYPqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYKYPqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:46:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:11732 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYKYPqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:46:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=H4eOvcYd/29lw2dWVinmwNf6JqDMZ2uGqThNm1LpSCQJvDy9f1t0WRpZNE5NQm8wK4
         V7ooVqiAdcsja5Di8svJp/SZ5+GXZ/oBby8YDpHLAXkEIQ4zTdMNAnT4xFQjUQMpYNYY
         fe5B58TvbGy+MZ1iyR1fFIJoWEnb40IWl44Ag=
Message-ID: <cfd18e0f0811250746i711205dej6b98f2fba6cecc42@mail.gmail.com>
Date: Tue, 25 Nov 2008 10:46:17 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Pavel Emelyanov" <xemul@openvz.org>
Subject: Re: Documentation for CLONE_NEWPID
Cc: "Kir Kolyshkin" <kir@openvz.org>, linux-man@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <492AA241.6050004@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4923810B.7010201@gmail.com> <492AA241.6050004@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Mon, Nov 24, 2008 at 7:46 AM, Pavel Emelyanov <xemul@openvz.org> wrote:
> Michael Kerrisk wrote:
>> Pavel, Kir,
>>
>> Drawing fairly heavily on your LWN.net article (http://lwn.net/Articles/259217/), plus the kernel
>> source and some experimentation, I created the patch below to document CLONE_NEWPID for the clone(2)
>> manual page.  Could you please review and let me know of any improvements or inaccuracies.
>
> Michael, sorry for the late response - I've been on vacation last week and didn't
> have chance to connect to check my mail.

No problem.

> Some comments are inline.

Thanks!

[...]

>> +This flag is intended for the implementation of control groups.
>
> Well, actually this has nothing to do with control groups. This
> flag is intended to be used to facilitate the creation of containers
> along with many other clone flags. Control groups is yet another
> way to create a container.

Yep, after an earlier mail from Eric, I already changed this to "containers".

>> +A PID namespace provides an isolated environment for PIDs:
>> +PIDs in a new namespace start at 1,
>> +somewhat like a standalone system, and calls to
>> +.BR fork (2),
>> +.BR vfork (2),
>> +or
>> +.BR clone (2)
>> +will produce processes whose PIDs within the namespace
>> +are only guaranteed to be unique within that namespace.
>
> Well, I'm not sure I understood correctly what was meant here, but after

I've simplified that sentence somewhat.  Now it just reads:

              A  PID  namespace  provides  an isolated environment for
              PIDs: PIDs in a new namespace start at 1, somewhat  like
              a  standalone system, and calls to fork(2), vfork(2), or
              clone(2) will  produce  processes  with  PIDs  that  are
              unique within the namespace.

> we have a namespace each task has two pids. And _all_ of them are unique
> in corresponding namespaces.

And I already make that point lower down in the text (see ***), but
now I extended the sentence there a little.

[...]

*** Here's where I make the point about each process having multiple PIDs"

>> +The existence of a namespace hierarchy means that each process
>> +may now have multiple PIDs:
>> +one for each namespace in which it is visible.

I added some words here:

"each of these PIDs is unique within the corresponding namespace".

>> +(A call to
>> +.BR getpid (2)
>> +always returns the PID associated with the namespace in which
>> +the process was created.)
>
> I don't thinks it's a good example - the getpid cannot be called
> for other process other than current :)

It wasn't meant as an example.  The point was, with a process
potentially being a member of multiple namespaces, the reader might
wonder: what does getpid(2) return?  This sentence was intended to
clarify that.  With that explanation, does this sentence now seem
okay?

[...]

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
