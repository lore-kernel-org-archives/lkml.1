Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbXIYPqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbXIYPqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbXIYPqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:46:12 -0400
Received: from h90-m1.hosting90.cz ([81.0.225.70]:37023 "EHLO
	h90-m1.hosting90.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258AbXIYPqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:46:10 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2007 11:46:10 EDT
Message-ID: <46F92BA7.8030304@prepere.com>
Date: Tue, 25 Sep 2007 17:39:19 +0200
From: Miloslav Semler <majkls@prepere.com>
User-Agent: IceDove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: serge@hallyn.com, davidsen@tmr.com, philipp@marek.priv.at, 7eggert@gmx.de,
       alan@lxorguk.ukuu.org.uk, bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
References: <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at> <46F29A9A.4070806@davidnewall.com> <200709201817.17282@x5> <46F2B59F.8090709@davidnewall.com> <46F2DDD0.3030500@tmr.com> <46F380E4.4040606@davidnewall.com> <20070924213215.GA32716@vino.hallyn.com> <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com> <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com> <Pine.LNX.4.64.0709251715390.945@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0709251715390.945@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Sep 26 2007 00:40, David Newall wrote:
>   
>> Miloslav Semler pointed out that a root process can chdir("..") out of its
>> chroot.  Although this is documented in the man page, it conflicts with the
>> essential function, which is to change the root directory of the process.  In
>> addition to any creative uses, for example Philipp Marek's loading dynamic
>> libraries, it seems clear that the prime purpose of chroot is to aid security.
>> Being able to cd your way out is handy for the bad guys, but the good guys
>> don't need it; there are a thousand better, safer solutions.
>>     
>
> So what? Just do this: chdir into the root after chroot.
>
> It won't conform to SVR4/4.4BSD anymore, but hey, let Linux set some
> sane standard ain't bad either. I doubt anyone really relies on the
> fact that after chroot, your cwd might be outside the root.
>   
so then you corrupt pwd. I think that working directory should be set 
only if it is necessary. Fn directory_is_out is not big performace loss. 
And also you can break this fix with fchdir.

Miloslav
