Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbXE3QLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbXE3QLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 12:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbXE3QLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 12:11:16 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:43325 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbXE3QLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 12:11:15 -0400
Date: Wed, 30 May 2007 18:04:27 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andy Whitcroft <apw@shadowen.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
In-Reply-To: <465D9933.2000209@oracle.com>
Message-ID: <Pine.LNX.4.61.0705301800330.11140@yvahk01.tjqt.qr>
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <p738xb8fjv2.fsf@bingen.suse.de>
 <465BECCC.5030001@shadowen.org> <Pine.LNX.4.61.0705292218520.11140@yvahk01.tjqt.qr>
 <20070529153651.d65fa07c.randy.dunlap@oracle.com>
 <Pine.LNX.4.61.0705301033470.11140@yvahk01.tjqt.qr> <465D9933.2000209@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 30 2007 08:33, Randy Dunlap wrote:
>> > That's just a joe bug then.
>> > 
>> > diff no longer requires a beginning space, at least in the testing
>> > that I did it worked with no leading space on a label:.
>> 
>> But not everyone runs the latest and greatest. diffutils 2.8.7
>> takes /^label:/ as a marker for the @@ line.
>
> OK.  What does "marker for the @@ line" mean?

if ($_ !~ /^[\(\[\{]/ && $_ =~ /^(\S+)/) {
    print "@@ -a,b +c,d @@ $1\n"
}

So
label:
will be the 'mark[er]' for the @@ line

Just try yourself:
<<< foo.c <<<
int main(void)
{
	x
	y
	z
label:
	a
	b
	c
	d
	e
	f
}
>>>
<<< foo2.c <<<
int main(void)
{
	x
	y
	z
label:
	a
	b
	c
	d
	d+
	e
	f
}
>>>
<<< diff -dpru foo.c foo2.c <<<
--- foo.c       2007-05-30 10:33:45.714222656 +0200
+++ foo2.c      2007-05-30 18:03:43.061471495 +0200
@@ -8,6 +8,7 @@ label:
 	b
 	c
 	d
+	d+
 	e
 	f
 }
>>>

	Jan
-- 
