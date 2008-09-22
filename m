Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbYIVTnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbYIVTnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 15:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYIVTm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 15:42:58 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34796 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754AbYIVTm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 15:42:57 -0400
Date: Mon, 22 Sep 2008 21:42:42 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ben Dooks <ben-linux@fluff.org>,
       Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] List of maintainers (draft #3)
Message-ID: <20080922194242.GA792@strlen.de>
References: <200202071054.g17Asst06608@Port.imtp.ilyichevsk.odessa.ua> <20080922081239.GA28726@strlen.de> <20080922091256.GH1916@fluff.org.uk> <84144f020809220223jbb71877ued9d3b2569c4cd67@mail.gmail.com> <48D7CA62.1020805@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D7CA62.1020805@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(hhm, my MTA failed to send my mail to Denis.  I'll try once more.)

On Mon, Sep 22, 2008 at 09:40:02AM -0700, H. Peter Anvin wrote:
> Pekka Enberg wrote:
>> Figuring out whom to send a patch to is not something you can automate
>> because it not only depends on what you're changing but *how* you're
>> changing it. The classic case being that whenever you change something
>> related to RCU that's non-trivial, you almost certainly want to CC
>> Paul "RCU" McKenney. But there's no *file* or *directory* pattern that
>> can automatically tell you this.
>> Furthermore, if you're hacking on a specific part of the kernel, you
>> almost certainly are doing it wrong if you don't know who the relevant
>> maintainers are. For simple janitorial patches, you probably should
>> just work out the *top-level* maintainers (davem for networking, ingo
>> et al for x86, and so on) and send the patches to them. And when these
>> simple rules fail you, fall back to patch bombing Andrew.
>
> This is, of course, true; however, there are people who should *always* be 
> included when touching specific files, and this *can* be automated. This is 
> particularly so when sending out cross-architectural patchsets.
>
> So no, automation isn't a substitute for intelligence, but that doesn't 
> mean that it can't be an *assistance*.
>
> We need this.  Right now too many people screw up even the part that *can* 
> be automated.
Thanks hpa.  That would have been roughly my response, too.  I can see
Pekka's point, too, but IMHO the advantages outweight the disadvantages.
This might result in some mails that don't reach the complete needed
audience, but it should assert that at least one right person is reached
and this one probably knows who to forward the mail.  I expect that in
most cases the automatic answer is right, though.

Continuing planning how to implement such an automation I found that
git-send-email already has an option --cc-cmd=/path/to/some/program.
program is called once per patch and should print email addresses to
stdout.  (This is already nearly optimal.  The only missing part is that
the addresses should occur in the resulting commit in a Cc: line.  This
could be implemented in program, too, but for me it feels wrong to do it
there.  IMHO git-send-email would be the better place.  I consider this
lower prio, though, so this has to wait (or be done by someone else).)

To go forward with how to specify a file <-> maintainer relation I
suggest to standardize a field F in MAINTAINERS that specifies the
associated files.  (There are already three entries that have such a
field.)  I'm not sure if the content should be a regular expression or
simply a list of files/directories.  The following arguments come to my
mind:
  - RE usually shorter (e.g. include/linux/netfilter.* substitutes
    11 files and directories).
  - list of files easier readable for humans.
  - list of files is more conceivable, e.g. you can pass each item to
    git-log.
Moreover I suggest to mark the introduction in MAINTAINERS with '#' to
ease parsing it.  (This is easy, I will reply with a patch.)

For in-file specification of maintainership I suggest similar to
MAINTAINERS:

	$TOPIC
	P: Joe H. Acker <joehacker@mail.do.main>
	L: linux-kernel@vger.kernel.org

in the first comment of the file.  (Supporting C-Style and #-comments.
Is anything more needed?)

I will start experimenting a bit and hope to provide some results soon.

I look forward to any constructive feedback.

Best regards
Uwe
