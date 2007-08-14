Return-Path: <linux-kernel-owner+w=401wt.eu-S933169AbXHNSHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169AbXHNSHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758331AbXHNSH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:07:26 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:55859 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344AbXHNSHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:07:25 -0400
Message-ID: <46C1EE6F.2080807@gmail.com>
Date: Tue, 14 Aug 2007 20:03:27 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: git@vger.kernel.org, Junio C Hamano <gitster@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -	scripts/get_maintainer.pl
References: <1186984174.10249.7.camel@localhost>	 <200708131933.10125.m.kozlowski@tuxland.pl>	 <1187026955.2688.4.camel@laptopd505.fenrus.org>	 <1187037445.6628.98.camel@heimdal.trondhjem.org>	 <1187054366.2757.0.camel@laptopd505.fenrus.org>	 <46C10AA8.3090505@gmail.com> <20070814102033.604c8695@the-village.bc.nu>	 <46C1CFFE.4000001@gmail.com> <1187110824.32555.76.camel@localhost>
In-Reply-To: <1187110824.32555.76.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2007 07:00 PM, Joe Perches wrote:

> On Tue, 2007-08-14 at 17:53 +0200, Rene Herman wrote:

>> It isn't about MODULE_FOO() tags, it is about tagging /source/ files 
>> to help with putting CCs on patch submissals.
>> If we want to link source file foo.c and the 
>> MAINTAINERS information, we have 3 options:
>> 1. MAINTAINERS --> foo.c
>> 2. foo.c --> MAINTAINERS
>> 3. foo.c <--> some 3rd file <--> MAINTAINERS
> 
> I added git@vger.kernel.org and Junio Hamano

Well, yes, I agree -- going through GIT seems to be the only really workable 
solution.

That is, instead of (case 2, you snipped it) having a backlink to the 
MAINTAINERS file in a header inside the source GIT would maintain this 
backlink -- and at that point, you can basically forego the MAINTAINERS file 
completely other than as something GIT can generate and just regard all of 
it meta-information (you may want to generate MAINTAINERS for releases but 
making GIT the source is the idea).

"git info --maintainer drivers/ide/ide-cd.c" or some such would say "Alan 
Cox <alan@...>".

There are more possibilities for this kind of meta information. git info 
--author, git info --license, git info --whatever. Given that it's intended 
for developers, needing GIT should not get in the way but there's always the 
generated MAINTAINERS file in releases as well.

It would ofcourse automatically stay up to date through deleting and moving 
of files. You'd probably want to devise a way to enable a submitter to also 
automatically provide meta-information upon addition of files. This can be 
done in the same way as a "Signed-off-by". Just tags in a submit email.

This should probably turn out to be the way things work yes. The paths in 
the MAINTAINERS file grow stale, source headers might also and sticking 
headers on every source file isn't nice anyway -- it's meta-information and 
the SCM can maintain it.

Rene.
