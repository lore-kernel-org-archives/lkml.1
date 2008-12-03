Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbYLCP5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbYLCP5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 10:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYLCP4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 10:56:52 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:25703 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYLCP4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 10:56:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=muVHg3NcdjRBw1UInCMyNACG7B+dPvGuYL2+J5Yrun84ciS2wviCiUqIa+Om/lBXBm
         XEuW47X8T6wVhen5fNlHvYT+3A08VXXe2bL4KBBD6WsnLP0re6ru8YhXd/7PxuzU8tYx
         heKM4wiE3JPki5e2ltuP7mFAWH4VyoFl8NVpg=
Message-ID: <2375c9f90812030756r5b8840e1u3980ddca8df27a6b@mail.gmail.com>
Date: Wed, 3 Dec 2008 15:56:50 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: Geralt <usr.gentoo@googlemail.com>
Subject: Re: Shebang - why are parameters not splitted on whitespace?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <fbdd0e50812030714md7dd899xeb8940798632b08b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fbdd0e50812030714md7dd899xeb8940798632b08b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2008 at 3:14 PM, Geralt <usr.gentoo@googlemail.com> wrote:
> Hi,
>
> I've just noticed, that it's not possible to use more than one
> parameter in a shebang on linux, because everything following the
> executable path in the shebang is treated as one parameter, so for
> example
> #!/bin/awk --re-interval -f
> in a script called "test.awk" results in a call likes this:
> /bin/awk "--re-interval -f" ./test.awk
> when running it with "./test.awk".
>
> Is there any reason why the parameters are not split before passing
> them on to the program?


Hello,

I think this behavior is different on different platforms, you can
find some clues
in man page of execve(2):

       The  semantics  of  the  optional-arg argument of an interpreter script
       vary across implementations.  On Linux, the entire string following the
       interpreter name is passed as a single argument to the interpreter, and
       this string can include white space.  However, behavior differs on some
       other  systems.   Some  systems  use the first white space to terminate
       optional-arg.  On some systems, an interpreter script can have multiple
       arguments,  and  white  spaces  in optional-arg are used to delimit the
       arguments

It seems that POSIX doesn't specify this.

Thanks.
