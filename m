Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbYLCRaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbYLCRaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 12:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbYLCR36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 12:29:58 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:50681 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbYLCR35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 12:29:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Cxxa1NxD0zJGhj2pKOxzlF7f75kJ1+pIwb5jzMwA6fshZ2peOewD50rKP3qgswmTuN
         dOaPIA433FTG5ik/tbeXYrO8fb0okU47KAP0L9Z64JyUojyR/6quvQUuwqrUPKWEqoAU
         rpE8IjzezDH5lduukLpjz0D+lMr3e0WJ9V6tc=
Message-ID: <fbdd0e50812030929s2d573981k46757c1b706f4cd5@mail.gmail.com>
Date: Wed, 3 Dec 2008 18:29:55 +0100
From: Geralt <usr.gentoo@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Shebang - why are parameters not splitted on whitespace?
In-Reply-To: <fbdd0e50812030929q65d2e805y49094dd67209be7e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <fbdd0e50812030714md7dd899xeb8940798632b08b@mail.gmail.com>
	 <2375c9f90812030756r5b8840e1u3980ddca8df27a6b@mail.gmail.com>
	 <fbdd0e50812030929q65d2e805y49094dd67209be7e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2008 at 4:56 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Dec 3, 2008 at 3:14 PM, Geralt <usr.gentoo@googlemail.com> wrote:
>> Hi,
>>
>> I've just noticed, that it's not possible to use more than one
>> parameter in a shebang on linux, because everything following the
>> executable path in the shebang is treated as one parameter, so for
>> example
>> #!/bin/awk --re-interval -f
>> in a script called "test.awk" results in a call likes this:
>> /bin/awk "--re-interval -f" ./test.awk
>> when running it with "./test.awk".
>>
>> Is there any reason why the parameters are not split before passing
>> them on to the program?
>
>
> Hello,
>
> I think this behavior is different on different platforms, you can
> find some clues
> in man page of execve(2):
>
>       The  semantics  of  the  optional-arg argument of an interpreter script
>       vary across implementations.  On Linux, the entire string following the
>       interpreter name is passed as a single argument to the interpreter, and
>       this string can include white space.  However, behavior differs on some
>       other  systems.   Some  systems  use the first white space to terminate
>       optional-arg.  On some systems, an interpreter script can have multiple
>       arguments,  and  white  spaces  in optional-arg are used to delimit the
>       arguments
>
> It seems that POSIX doesn't specify this.
>
> Thanks.
>

Hello,

I should have anticipated this objection :-). I'm aware that this is
not consistent among Unix operating systems (you can find more about
it here [1]), but I was specifically refering to linux in this case
and why it handles the shebang arguments as one big string and not as
single arguments for the application.



Geralt.


[1] http://www.in-ulm.de/~mascheck/various/shebang/
