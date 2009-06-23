Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbZFWWMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbZFWWMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbZFWWMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:12:00 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:52854 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbZFWWL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:11:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=p6jiBbyy/AR5BLmEA+k48j2HQikEoj0fXgQ4hp22i99wjTI8ytpknPYNTWKFBEJ9qR
         v6iUFRnv/08FKo4FZ83KQ+kCwkpX7ullZX6Z/zyD16xBsq6Ks5+ESgn5b2FPzgcr6HZE
         QWeJsvw8UR6xM5VzxrUQ2izzeZX50qQeLJxPQ=
MIME-Version: 1.0
In-Reply-To: <200906240006.10881.arnd@arndb.de>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org> 
	<200906232314.18261.arnd@arndb.de> <8bd0f97a0906231453m308dc972mdf624545794f398e@mail.gmail.com> 
	<200906240006.10881.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 23 Jun 2009 18:11:42 -0400
Message-ID: <8bd0f97a0906231511nbac1a3cw1505a51fc2dd837d@mail.gmail.com>
Subject: Re: [PATCH 05/17] Blackfin: convert to generic checksum code
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michal Simek <monstr@monstr.eu>, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 18:06, Arnd Bergmann wrote:
> On Tuesday 23 June 2009, Mike Frysinger wrote:
>> and this is an internal tester ... if we're going to let arches
>> override it, then its function signature are pretty much set in stone.
>> i agree we should test every checksum function, but i think only
>> testing do_csum indirectly would be detrimental to the people who
>> would want to use this -- arch maintainers looking to implement
>> do_csum() themselves.  otherwise they need to step through the
>> surrounding functions a bit to find the exact values given to
>> do_csum() and the exact value expected back such that the calling
>> function still works.  and every arch guy is going to do this same
>> thing.
>
> It depends on how we want to use it. If it's only for testing architecture
> that have moved to the generic checksum code, that's fine. I was
> thinking we could also use it for architectures that want to keep
> their own code, but we don't have to.

ah, i see what you're going for.  how about we make testing of
do_csum() dependent upon GENERIC_CSUM.  that way we can satisfy
everyone.

any other suggestions for coming up with test vectors ?  or i just
extract a few more examples from flooding my board and call it a day.
if someone complains a bug existed and current test vectors didnt
cover it, then they should submit a new one.
-mike
