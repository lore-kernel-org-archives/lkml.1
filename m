Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYKOLb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYKOLb5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 06:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbYKOLbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 06:31:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40167 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202AbYKOLbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 06:31:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: ACPI: EC: GPE storm detected, transactions will use polling mode
Date: Sat, 15 Nov 2008 12:36:15 +0100
User-Agent: KMail/1.9.9
Cc: "Alexey Starikovskiy" <aystarik@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
References: <1226722577.3104.4.camel@LiNuX> <491E94FD.4090002@gmail.com> <9b2b86520811150237r454b0a38l8d34f0e322573da@mail.gmail.com>
In-Reply-To: <9b2b86520811150237r454b0a38l8d34f0e322573da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811151236.16748.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 15 of November 2008, Alan Jenkins wrote:
> On Sat, Nov 15, 2008 at 9:23 AM, Alexey Starikovskiy <aystarik@gmail.com> wrote:
> > Andrew Morton wrote:
> >>
> >> (cc linux-acpi)
> >>
> >> On Fri, 14 Nov 2008 20:16:17 -0800 "Justin P. Mattock"
> >> <justinmattock@gmail.com> wrote:
> >>
> >>  
> >>>
> >>> just pulled the latest git today and am now noticing
> >>> the lovely gpe storm being triggered.(dmesg below);
> >>>    
> >>
> >> Are any other effects observeable?
> >>
> >> I assume that 2.6.27 didn't do this.
> >>
> >>  
> >
> > It did. Justin even opened a bug -- #11724.
> 
> In case anyone else tries to follow that, it's actually #10724 :).

Yes, the "transaction in interrupt context" patch fixed that IIRC and the one
of the patches in the recet ACPI merge broke it again.

Justin, can you see if reverting one or more of the following commits helps:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8517934ef6aaa28d6e055b98df65b31cedbd1372
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=06cf7d3c7af902939cd1754abcafb2464060cba8
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0b7084ac67fb84f0cf2f8bc02d7e0dea8521dd2d
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a2f93aeadf97e870ff385030633a73e21146815d
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=dd15f8c42af09031e27da5b4d697ce925511f2e1
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f8248434e6a11d7cd314281be3b39bbcf82fc243
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cfe62c8010ac56e1bd3827e30386a87cc2f3594

(please revert in this order)?

Thanks,
Rafael
