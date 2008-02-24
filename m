Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbYBXEec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbYBXEec (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 23:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbYBXEeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 23:34:24 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34916 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbYBXEeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 23:34:23 -0500
Message-ID: <47C0E3D7.50901@davidnewall.com>
Date: Sun, 24 Feb 2008 13:56:15 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Pavel Machek <pavel@ucw.cz>, Krzysztof Halasa <khc@pm.waw.pl>,
       Jeff Garzik <jeff@garzik.org>, Adrian Bunk <bunk@kernel.org>,
       Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org> <m3tzk1q3rt.fsf@maximus.localdomain> <47BE0C12.604@garzik.org> <m3k5kxq2ih.fsf@maximus.localdomain> <20080222184518.GB6060@ucw.cz> <m3zlts393a.fsf@maximus.localdomain> <20080223094334.GA3081@elf.ucw.cz> <47C013E2.6040201@davidnewall.com> <alpine.LFD.1.00.0802230913380.21332@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802230913380.21332@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Sat, 23 Feb 2008, David Newall wrote:
>   
>> Do you actually get 80 columns wide on it?
>>     
>
> Do people really care that deeply?
> ...
> And do I find lines longer than 80 charactes unreadable? Hell no.
>   

I care, yes.  I've found my code looks much prettier, with attendant
improvement in ease of understanding, since I stopped being so anal
about 80 columns.  The width of the code, that is first to last
non-blank on each line, is about the same, not  because I work to keep
it narrow, but because most statements just are narrow.  Sometimes I do
get really wide statements, for example when using deep data structures,
especially as parameters in procedure calls, and this is easier to read
than having to break the line.

I honestly think the reason we used to insist on lines less than 80
characters was because on an 80 character screen, you get slightly
better readability by choosing where to break each line than simply
letting the hardware do it.  We don't have the physical limit any more,
so we don't need to impose it structurally.

It's about readability, and with due respect, people who've never tried
it aren't qualified to comment.

> which talks more about what matters - too deep indentation.
What's too deep?  Is the following too deep?  It's common enough, other
than my refusal to relax consistent indenting style for switch bodies. 
The code is readable, and breaking it into multiple procedures just to
de-indent is often impossible, and rarely readable.  With a strict 80
character limit, the meat in the sandwich is left with only 20 or so
characters in which to fit.  Add a nested switch, and there's virtually
no space left for code.

123456789012345678901234567890123456789012345678901234567890123456 (70)
int procedure(param list)
{
	switch (condition)
	{
		case value:
			if (another_condition)
			{
				if (variant)
					meat_in_sandwich;
			} else {
				code;
			}
		case value2:
			switch (sub_condition)
			{
				case sub_value:
					if (final_test)
					{
						something(	
							NULL,
							1,
							"two");
					}
			}
	}
}


(Yes, I know, "we don't indent 'case' because it consumes too much
room."  That's inconsistent with the rest of normal indenting style, and
a poor excuse to keep within an obsolete and unnecessary restriction.)
