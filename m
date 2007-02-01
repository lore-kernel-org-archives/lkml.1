Return-Path: <linux-kernel-owner+w=401wt.eu-S1422912AbXBAPFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422912AbXBAPFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422914AbXBAPFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:05:24 -0500
Received: from main.gmane.org ([80.91.229.2]:56354 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422912AbXBAPFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:05:23 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [patch, rfc] kbuild: implement checksrc without building Cources...
Date: Thu, 1 Feb 2007 15:04:35 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnes40sp.m64.olecom@flower.upol.cz>
References: <20061023153540.4d467a88.rdunlap@xenotime.net> <slrnejscd5.93p.olecom@flower.upol.cz> <slrnejsrjq.93p.olecom@flower.upol.cz> <20061024134508.adb14be6.rdunlap@xenotime.net> <20061026130720.GA2765@flower.upol.cz>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>, Oleg Verych <olecom@flower.upol.cz>
User-Agent: slrn/0.9.8.1pl1 (Debian)
Cc: kbuild-devel@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Oleg Verych
> Newsgroups: gmane.linux.kernel,gmane.linux.kbuild.devel
> Subject: Re:[patch, rfc] kbuild: implement checksrc without building Cources...
> Date: Thu, 26 Oct 2006 15:07:20 +0200
> Archived-At: <http://permalink.gmane.org/gmane.linux.kernel/460736>

> On Tue, Oct 24, 2006 at 01:45:08PM -0700, Randy Dunlap wrote:
>> On Tue, 24 Oct 2006 19:43:40 +0000 (UTC) Oleg Verych wrote:
>> > This doesn't work, use ifs instead. Updated.
>> > I have no idea what to do with generated sources and headers.
>> > One may be: check target `if_changed' to be %.c or %.h and let it be
>> > built.
>> 
>> Hi Oleg,
>> 
>> Yes, it works for me, with the exception of host-generated
>> files, as you mentioned.  I ran into those with:
>> IKCONFIG (the one that you mentioned), ATM_FORE200E firmware,
>> IEEE 1394 OUI database (which I sent a patch for -- it should
>> not be generated when the config option is not enabled),
>> RAID456 tables, VIDEO_LOGO files, and CRC32 table.
>
> I'm glad, that semi-working thing was helpful. But it's ugly hack.
>
> Idea is to substitute objects (*.o) with sparse output, thus targets
> like
> ,--
>|%.o : %.c
> +--
> will be updated and new check will pass them (force check may be applied).
> Also having results in files (even in so messy called *.o) is good for
> collecting and sorting errors. Headers will be generated as needed.
>
> Finally short statistics maybe printed in the end of the check:
> [(stat -c %s *.o > 0 | wc -l) / find --name *.o]
>   ^ with error file size > 0  / overall error files
>
> But implementing all this in non-hack way isn't easy. Maybe Sam will
> came back and will do it magically quickly. Until that, i'll try to
> fight with current makefiles myself.
>
>> Thanks for your time and effort.  Maybe Sam will have some ideas.
>
> I've found "sparse" and read some philosophy from README. Nice.
> Thanks you also !
> ____

So far nothing has changed. Is it still worth to try to make more
comprehensive solution ?

p.s. Note. Please honor "Mail-Followup-To" header. Thanks.
____

