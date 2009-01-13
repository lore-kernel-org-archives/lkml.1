Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbZAMBUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbZAMBUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756989AbZAMBUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:20:32 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:37590 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816AbZAMBUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:20:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qou44bvNdKK/cwtyuFLQEcrTjMN1qOuYZPTTrhFkSyI6ZIjicMd0aTIrHIqTR5A7Hh
         KflDSTGRynC+2s1+zEwjToGj9i0kTQ0amq0cPyfSWXhA7c7nR2se6373fUGxFLpfS644
         4Iyro+c2MSIp7CyH81CuhbnHpAEbaWv+psv+8=
Message-ID: <b6a2187b0901121720s1f9b12ednb76a90dcc7eddc81@mail.gmail.com>
Date: Tue, 13 Jan 2009 09:20:29 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
Cc: "Christian Borntraeger" <borntraeger@de.ibm.com>,
       "Daniel Drake" <dsd@gentoo.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Phil Dibowitz" <phil@ipom.com>
In-Reply-To: <20090111180714.GB15326@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
	 <b6a2187b0901110813s5429573cm7d78f39e288f70a3@mail.gmail.com>
	 <20090111162949.GA15338@elte.hu>
	 <200901111736.24350.borntraeger@de.ibm.com>
	 <20090111163904.GA21806@elte.hu>
	 <b6a2187b0901110856j3f2ff6fepc19a816178e38a95@mail.gmail.com>
	 <20090111180714.GB15326@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 2:07 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> Everything in-between should have
>> a0e280e0f33f6c859a235fb69a875ed8f3420388 applied?
> not necessarily - if an intermediate tree that is checked happened to have
> been based on some earlier -rc, it might have that bug included. Safest is
> to always cherry-pick that commit. (if it has no dependencies)

Thanks for pointing this out. My bisect was thrown off course because
I didn't "cherry-pick" that commit.

After cherry picking, I ended up with the same commit as was reported by
Christian Borntraeger -- "Regression 2.6.28-git: suspend/resume
failure. git bisected to usb suspend/resume patch".

I was trying to bisect further, but ended up with this strange behavior...

# start with a "fresh linux git download".
# ls
.               ..             .git     .gitignore   .mailmap  COPYING
CREDITS         Documentation  Kbuild   MAINTAINERS  Makefile  README
REPORTING-BUGS  arch           block    crypto       drivers   firmware
fs              include        init     ipc          kernel    lib
mm              net            samples  scripts      security  sound
usr             virt

# git bisect bad ae04d1401577bb63151480a053057de58b8e10bb
# git bisect good a3a798c88a14b35e5d4ca30716dbc9eb9a1ddfe2
Bisecting: 579 revisions left to test after this
[079899c2384023cd8efcd3806680b4f1d2abbd54] Btrfs: Change
find_extent_buffer to use TestSetPageLocked

# ls
.  ..  .git  fs

Is this a bug or a feature?


Jeff.
