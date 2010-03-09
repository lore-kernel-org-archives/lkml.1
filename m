Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab0CIAvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 19:51:50 -0500
Received: from mail-iw0-f176.google.com ([209.85.223.176]:57474 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab0CIAvs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 19:51:48 -0500
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2010 19:51:48 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=nJWDv+J1Gaki3PHV7jpap07sdwioUddyXmU7DewZe/xalgIFouTSDB/qw+/kxYmZeY
         22KKyPz0cG1+vI5nM6h4V7XqDWZ3Ei3l+8dkp0kIXUuIKcFfADyGuz8gzm3SV531cbcr
         +m5J2HHyg/EyzOZUmNkJbshNQC70EcapWkUW4=
MIME-Version: 1.0
In-Reply-To: <20100306002414.GJ28657@tango.0pointer.de>
References: <20100202120457.GA19605@omega> <20100304140822.GA458@redhat.com> 
	<20100304221434.17567187@magilla.sf.frob.com> <ac3eb2511003051051r50468752o607a8a0309d5ce2e@mail.gmail.com> 
	<20100305191816.5EC8ACC@magilla.sf.frob.com> <20100306002414.GJ28657@tango.0pointer.de>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Mon, 8 Mar 2010 16:45:38 -0800
X-Google-Sender-Auth: 844209019d1968b6
Message-ID: <2c0942db1003081645y4063ed29va6763151f53a282a@mail.gmail.com>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers for 
	child processes
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Roland McGrath <roland@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Americo Wang <xiyou.wangcong@gmail.com>,
       James Morris <jmorris@namei.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Kyle McMartin <kyle@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 4:24 PM, Lennart Poettering <mzxreary@0pointer.de> wrote:
> On Fri, 05.03.10 11:18, Roland McGrath (roland@redhat.com) wrote:
>
>>
>> > Oh, no. Actually getting the SIGCHILD is the needed feature here. A
>> > process who sets the ANCHOR flag is surely expected to handle these
>> > signals. It's all about a user "init-like" process" that can do
>> > similar things for a logged-in user what /sbin/init can to for the
>> > system. So, it's all about 1.), and 3.) is a nice side-effect, but not
>> > the motivation to do this.
>>
>> Please explain this more explicitly.  What the actual init does with
>> miscellaneous reparented processes is just reap them and ignore their
>> status.  What do you intend an "anchor" process to do other than that?
>
> It could use the grandchildren's SIGCHLDs for various task management
> issues: i.e. watching double-forking daemons, catch SIGSEGVS so that you
> can crosslink that service state to systems like abrt. Or even just that
> you can implement a safe restarting logic: i.e. so that we can easily
> wait that a process and its children are fully dead before we restart
> the service.

The kernel already offers system-wide process exit notification via
taskstats (a netlink interface), though unfortunately I believe it's
optional. It's pretty easy to use (as these things go, anyway -- I was
able to hack up an arbitrary process exit watcher in about a half hour
based on Documentation/accounting/getdelays.c).

Would this existing mechanism cover what you need?
