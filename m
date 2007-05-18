Return-Path: <linux-kernel-owner+w=401wt.eu-S1761553AbXERRWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761553AbXERRWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 13:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756573AbXERRWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 13:22:23 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:12513 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbXERRWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 13:22:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tUFPlfThheDaCtB2FMcblcEq/1bywz5cxApZjEqUYa9gaj420pfKk09Gt4Jj2wil0v/Elvj6fJqywjNXq7W6/9HVVlLAbIgMXMO+aHCoRuxhT3xuDZcRWXoXf4qe3+xEn0/hrZ+Y/Wi3DSJRyzOf8KHN8EdYjpIUAkMu8q55nCs=
Message-ID: <25ae38200705181022l35e0b364p98fc39e5739612b@mail.gmail.com>
Date: Fri, 18 May 2007 22:52:15 +0530
From: "Anand Jahagirdar" <anandjigar@gmail.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: Fork Bombing Attack
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       linux-kernel@vger.kernel.org, "Coywolf Qi Hunt" <coywolf@sosdg.org>
In-Reply-To: <1865922a0705180619g2a997c2ch5d13be3e023630e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <25ae38200705170745t4a80e7eer413b3c2bb0c5a327@mail.gmail.com>
	 <4051.1179414105@turing-police.cc.vt.edu>
	 <25ae38200705180413s741cac1bw9fe0dc57cecc2a91@mail.gmail.com>
	 <1865922a0705180619g2a997c2ch5d13be3e023630e0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All
           I found one more interesting thing related with fork
bombing attack. i have set following in /etc/security/limits.conf file

     #@root    hard  nproc  3000
     #@anand hard  nproc  500


I have tried to execute fork bombing program on the same machine. it
killed the box completely and machine needed a reboot. will any body
please tell me why this is so? even after setting limits in
/etc/security/limits.conf file.

about ulimit:
ulimit are by default  set to some value for all users.. root, guest.
on my machine with FC4 distribution when i typed command "ulimit -u"
it gave me output as 3055 and another machine having FC6 distribution
output is 8050. when root or any other user changes ulimit by typing
"ulimit -u value",.ulimit value is changed for that session and not
permantely. actually ulimit should help to prevent fork bombing attack
but it wont and fork bombing attack still take down the machine having
latest linux distributions.

will any please tell me why this is so?

Regards
Anand

On 5/18/07, Ahmed S. Darwish <darwish.07@gmail.com> wrote:
> On 5/18/07, Anand Jahagirdar <anandjigar@gmail.com> wrote:
> > Hello All
> >            I tried to execute a program which creates 8152 process.(
> > i=0; while( i<14) i++ fork(); )  with ulimit 8200. This program
> > created 8152 processes and then stopped and came back to command
> > prompt. this proves that my machine do have sufficient resources to
> > create 8000 processes.
> >
> >            I found one more interesting thing on the same machine
> > having FC6 distribution and Linux Kernel 2.6.18. i have set "ulimit -u
> > 100". after setting this limit i tried to execute fork bombing program
> > with guest account. after executing it
> >
> > expected result:-  guest uesr should not able to fork another single
> > process when it reaches to 100 processes count.
> >
> > actual result :-  kernel allow me to create another processes without
> > giving error. due to this i tried to execute same fork bombing program
> > on another terminal with guest account and this fork bombing attack
> > killed the box completely and machine needed reboot.
> >
>
> I think if you want resource limiting per _UID_ (and not per _process_
> as you did), you should use PAM module pam_limits.so. You can edit
> those limits using the file /etc/security/limits.conf
>
> Regards,
> --
> Ahmed S. Darwish
> http://darwish-07.blogspot.com
>
