Return-Path: <linux-kernel-owner+w=401wt.eu-S1760564AbXFDVEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564AbXFDVEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbXFDVEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:04:34 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:15011 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678AbXFDVEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p+Z7BbYpFQtfoDPPHudD9UIzsRdYF87WzQN5ygFEhISkDEYUG70pBkQ4ZwH8sH465qpSBcrM39AEwcbdvwvjM+ry9GblhLP8CKhZ/jE7qkH2Et88ZGNSGhYQkpXKdnlNgVHptf+3mXaf9qGzJgsK1J0irBq2g44nZeYNL56w+Pk=
Message-ID: <b637ec0b0706041404j7647fd7ele5243ef9a42b536c@mail.gmail.com>
Date: Mon, 4 Jun 2007 23:04:31 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.22-rc2: known regressions with patches
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       "Uwe Bugla" <uwe.bugla@gmx.de>, "Ken Chen" <kenchen@google.com>,
       xfs-masters@oss.sgi.com, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "David Chinner" <dgc@sgi.com>,
       "Andrea Righi" <righiandr@users.sourceforge.net>,
       "Christoph Lameter" <clameter@sgi.com>, linux-ide@vger.kernel.org,
       "Paul Mundt" <lethal@linux-sh.org>, "Tejun Heo" <htejun@gmail.com>,
       "Jeff Garzik" <jeff@garzik.org>,
       "Francis Russell" <francisrussell@btopenworld.com>,
       "Alan Cox" <alan@redhat.com>, "Andi Kleen" <ak@suse.de>,
       discuss@x86-64.org, "Ben Collins" <ben.collins@ubuntu.com>
In-Reply-To: <46559B62.5040903@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46559B62.5040903@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

> Block devices
>
> Subject    : loop devices limited to one single device
> References : http://lkml.org/lkml/2007/5/16/229
> Submitter  : Uwe Bugla <uwe.bugla@gmx.de>
> Handled-By : Ken Chen <kenchen@google.com>
> Patch      : http://lkml.org/lkml/2007/5/21/483
> Status     : patch available
>

I just noticed that I have this issue; anyway, this patch works fine
for me (with -rc3)

[root@tycho mnt]# mkdir 1  2  3  4  5 6
[root@tycho mnt]# for i in `ls`
> do
> mount -o loop=/dev/loop$i /home/F-7-i386-DVD.iso /mnt/$i
> done
[root@tycho mnt]# df -k
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda2              4061572   2910092    941408  76% /
/dev                    515908        36    515872   1% /dev
none                    515908        16    515892   1% /dev/shm
/dev/sda4             27617068   7206108  19008084  28% /home
/home/F-7-i386-DVD.iso
                       2832620   2832620         0 100% /mnt/1
/home/F-7-i386-DVD.iso
                       2832620   2832620         0 100% /mnt/2
/home/F-7-i386-DVD.iso
                       2832620   2832620         0 100% /mnt/3
/home/F-7-i386-DVD.iso
                       2832620   2832620         0 100% /mnt/4
/home/F-7-i386-DVD.iso
                       2832620   2832620         0 100% /mnt/5
/home/F-7-i386-DVD.iso
                       2832620   2832620         0 100% /mnt/6

Regards,
Fabio
