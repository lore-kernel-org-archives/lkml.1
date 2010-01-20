Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767Ab0ATDQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab0ATDQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 22:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678Ab0ATDQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 22:16:20 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:54858 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab0ATDQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 22:16:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kJViKBr3Urgk/WOIJOXqp8zhzMjIMMN+SQxfu5SusYskbcLhPwjMZ1RBe/ZWVRWMLp
         RoTsxvHrk2UFXUMENBodkUIfMkVJkHZepCxVyp/ruKCNEtXGX/wWrdw+yMjoYnapZn8i
         rD0NP3fhAjmYTTno0GC5L1Y83wd4JgfRi9fL8=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a1001191118q4d8f5e02he6df84a654a66d69@mail.gmail.com>
References: <1263883920-17289-1-git-send-email-vapier@gentoo.org>
	 <20100119142545.GB3473@hack>
	 <8bd0f97a1001190923p6104acb4if5ec7225d549b713@mail.gmail.com>
	 <520f0cf11001190942n2c765618m8a66b8afe82010d0@mail.gmail.com>
	 <8bd0f97a1001190954q62b3bc5ejbdb69684d61c087c@mail.gmail.com>
	 <alpine.LFD.2.00.1001191900340.5999@localhost.localdomain>
	 <8bd0f97a1001191118q4d8f5e02he6df84a654a66d69@mail.gmail.com>
Date: Wed, 20 Jan 2010 11:16:18 +0800
Message-ID: <2375c9f91001191916l18588245ndf6c50aa2723fb08@mail.gmail.com>
Subject: Re: [PATCH] kconfig: dont hardcode path to lsmod
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: John Kacur <jkacur@redhat.com>, Steven Rostedt <srostedt@redhat.com>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 3:18 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Tue, Jan 19, 2010 at 13:12, John Kacur wrote:
>> On Tue, 19 Jan 2010, Mike Frysinger wrote:
>>> On Tue, Jan 19, 2010 at 12:42, John Kacur wrote:
>>> > On Tue, Jan 19, 2010 at 6:23 PM, Mike Frysinger wrote:
>>> >> On Tue, Jan 19, 2010 at 09:25, Américo Wang wrote:
>>> >>> On Tue, Jan 19, 2010 at 01:52:00AM -0500, Mike Frysinger wrote:
>>> >>>>The lsmod utility has always been installed into /bin with the newer
>>> >>>>module-init-tools package, so let lsmod be found via PATH instead of
>>> >>>>hardcoding the old modutils /sbin path.
>>> >>>>
>>> >>>
>>> >>> Some distro doesn't set /sbin to PATH, so for me a better solution
>>> >>> would be making PATH contain /sbin, and then use "lsmod".
>>> >>
>>> >> read my changelog -- module-init-tools has always installed into /bin.
>>> >>  so what your distro does with /sbin doesnt matter.
>>> >
>>> > I prefer my patches work for the real-world instead of the "so what
>>> > your distro does doesn't matter" world.
>>>
>>> try reading my comment instead of getting huffy.  if you have a distro
>>> that does something stupid like break the correct default m-i-t
>>> install setup, you should actually point it out.  the ones i checked
>>> were sane and installed lsmod into /bin (and some symlinked lsmod for
>>> backwards compat with modutils into /sbin).
>>
>> Well, I'm currently running Fedora (10 thru 12), and lsmod is in /sbin
>> Your patch would still not break for me because /sbin is in the PATH.
>>
>> However if Américo is correct that there are distros that have lsmod in
>> /sbin and don't have /sbin in the PATH, then your patch would break them.
>> You can argue that the distro is doing something stupid, but I'll bet you
>> they will blame your patch for breaking them. It seems reasonable to
>> me that a distro might only put /sbin in the superuser path, so I can
>> imagine there are cases like Américo suggests.
>
> i am saying they're stupid for doing this, but i'm not saying we
> shouldnt support it.  the premise for my original patch was that
> upstream m-i-t has always used /bin (which means all 2.6 module
> handers should be there per upstream), and the downstream distros i
> had access to followed upstream's direction.
>
> sounds like Fedora should have a bug report to get their things fixed
> ... there's no reason for `lsmod` to not be in /bin (and everyone's
> PATH) since it only reads /proc/modules and that is word readable.

This certainly makes sense, but the fact is that lsmod is still there,
what is worse, on RHEL (Fedora too, I think) /sbin is not in PATH
of my zsh.
