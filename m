Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbYFQR7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbYFQR7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 13:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758466AbYFQR7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 13:59:05 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:43750 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbYFQR7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 13:59:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Dgdh+YK/zm8EfzctYU2CPOBjENqZSgVoUkHb3d6k32SiWB3rUNftVwkIb3QGa5GohD
         SbKmD1XcaryfEp8rxp98NtiwO5pKEV7xRMwpYa6HC8XxBNoxd6GbcPfthum9VvUvV9co
         FGG7qlgh2uXKTiZuciAh1PGJosnY4LXdEh9XI=
Message-ID: <cfd18e0f0806171059l42783342h9ff68b0761c8a2e@mail.gmail.com>
Date: Tue, 17 Jun 2008 19:59:00 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Andrea Arcangeli" <andrea@qumranet.com>
Subject: Re: PR_SET_SECCOMP and PR_GET_SECCOMP doc (and bug?)
Cc: Valdis.Kletnieks@vt.edu, "Ivana Varekova" <varekova@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org
In-Reply-To: <20080617173411.GC28087@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48565951.40603@gmail.com> <20080616162543.GA9552@duo.random>
	 <cfd18e0f0806170632p27a5ccd2obadaf0dfd4ce64aa@mail.gmail.com>
	 <18697.1213719134@turing-police.cc.vt.edu>
	 <20080617173411.GC28087@duo.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 7:34 PM, Andrea Arcangeli <andrea@qumranet.com> wrote:
> On Tue, Jun 17, 2008 at 12:12:14PM -0400, Valdis.Kletnieks@vt.edu wrote:
>> On Tue, 17 Jun 2008 15:32:29 +0200, Michael Kerrisk said:
>> > On Mon, Jun 16, 2008 at 6:25 PM, Andrea Arcangeli <andrea@qumranet.com> wrote:
>> > > On Mon, Jun 16, 2008 at 02:15:13PM +0200, Michael Kerrisk wrote:
>>
>> > >>     PR_GET_SECCOMP (since Linux 2.6.23)
>> > >>         Return the secure computing mode  of  the  calling  thread.
>> > >>         Not  very  useful: if the caller is not in secure computing
>> > >>         mode, this operation returns 0; if the caller is in  secure
>> > >>         computing  mode, then the prctl() call will cause a SIGKILL
>> > >>         signal to be sent to the process.  This operation  is  only
>> > >>         available  if  the kernel is configured with CONFIG_SECCOMP
>> > >>         enabled.
>>
>> Would it make sense to change the text to read "Not very useful for the
>> current implementation of mode=1" and/or add that it may be useful for
>
> Yes, makes sense to me ;).

I've made a change something like you suggest, Valdis.  But I'm still
not really convinced that it will be useful in the future.  The
problem is that as things stand, we would *never* be able to safely
make the prctl(PR_GET_SECCOMP) call, since there is a chance (if mode
is 1) that we would be killed by SIGKILL.



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
