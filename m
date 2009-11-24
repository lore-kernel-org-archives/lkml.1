Return-Path: <linux-kernel-owner+w=401wt.eu-S933172AbZKXPHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172AbZKXPHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757995AbZKXPHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:07:23 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:61220 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477AbZKXPHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uctV90FX6Zk+ggDxh88eCNsZI7h7SHe0hbadLssWU4rEeWCQ144ZIFLbHQXOLguwK7
         Lk4+XEGIkxC7ehs6GRUq8i4QmhlKhIPCUUSkLiADgBpOVqiEM7OuQ7uZpMnqpqCmFFoF
         K50iTN3jH6/e5FmJlfJC8IDvc1Pz8hy3Am3jw=
MIME-Version: 1.0
In-Reply-To: <1259074194.3019.106.camel@cail>
References: <1259068293.3019.15.camel@cail>
	 <4e5e476b0911240603q7df022bx5b5915aab6279537@mail.gmail.com>
	 <1259074194.3019.106.camel@cail>
Date: Tue, 24 Nov 2009 16:07:26 +0100
Message-ID: <4e5e476b0911240707kfa6e509s6b557a9b4d1cc9d1@mail.gmail.com>
Subject: Re: [PATCH 0/1] Correct sorting problem in cfq_service_tree_add
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,
On Tue, Nov 24, 2009 at 3:49 PM, Alan D. Brunelle <Alan.Brunelle@hp.com> wrote:
>
> Having read the ioprio.txt I had thought that the priorities within a
> class should still be honored and that the time slice calculations in
> cfq_prio_slice would be left as is. "ioprio" is probably the wrong field
> name in the code (and text) then, as it is not meant as a priority but
> as a time slice indicator?! The text in ioprio.txt and in the man page
> for ionice are very inconsistent here: For example, the ionice man page
> states: "This [best effort] class takes a priority argument from 0-7,
> with lower number being higher priority. Programs running at the same
> best effort priority are served in a round-robin fashion." Which implies
> a secondary sort-order for priority within a class. Of course, both
> ioprio.txt and the ionice man page also talk about class levels in a way
> that may indicate it is not priority based. Hm...

ionice man page is usually not in sync with the kernel. It should
really just point at the kernel doc, since it is just an interface to
set up parameters, that will then be interpreted by the kernel (or
list the different interpretations for those at each kernel
incarnation, but this is infeasible).

ioprio.txt in my kernel tree says quite explicitly that RT can starve
BE, and IDLE is starved by anyone.
Moreover, it says:
RT: Within the RT class, there are 8 levels of class data that
determine exactly how much time this process needs the disk for on
each service.
BE: The class data determines how much io bandwidth the process will
get, it's directly mappable to the cpu nice levels just more coarsely
implemented. 0 is the highest BE prio level, 7 is the lowest.

This is still a bit confusing, since it says disk time for RT and bw
for BE, while the implementation is the same for both, time based.

BTW, if you want to review CFQ, you should look at
http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=refs/heads/for-2.6.33,
where cfq development for next kernel version is taking place.

Thanks
Corrado
