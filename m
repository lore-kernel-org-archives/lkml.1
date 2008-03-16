Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbYCPAPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbYCPAPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 20:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYCPAPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 20:15:44 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:23916 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbYCPAPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 20:15:43 -0400
X-Spam-Flag: NO
X-Spam-Score: -6.389
Message-ID: <47DC66A8.1020905@tremplin-utc.net>
Date: Sun, 16 Mar 2008 01:15:36 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.12) Gecko/20080305 Mandriva/2.0.0.12-3mdv2008.1 (2008.1) Thunderbird/2.0.0.12 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tilman Schmidt <tilman@imap.cc>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>  <47D86D43.2060108@imap.cc> <1205441216.4971.65.camel@nimitz.home.sr71.net>  <47D9C853.3040701@imap.cc> <1205517802.12763.18.camel@nimitz.home.sr71.net>  <1205525184.12763.32.camel@nimitz.home.sr71.net>  <47DAE55C.3080506@tremplin-utc.net>  <1205530551.8167.20.camel@nimitz.home.sr71.net>  <47DB013D.3060102@tremplin-utc.net> <1205537395.8167.31.camel@nimitz.home.sr71.net> <47DBC578.7050101@imap.cc> <alpine.LFD.1.00.0803151212180.3020@woody.linux-foundation.org> <47DC26BC.7060502@tremplin-utc.net> <alpine.LFD.1.00.0803151315250.3020@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803151315250.3020@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

15/03/08 21:19, Linus Torvalds wrote/a écrit:
> What's the problem with just loading a new DSDT later? Potentially as in 
> *much* later: including when user-space is all up-and-running? 
> 
:
> So what's the reason for pushing for this insanely-early workaround in the 
> first place, instead of letting user-space do something like
> 
> 	cat my-dsdt-image > /proc/sys/acpi/DSDT
> 
> or whatever at runtime?
Yeah, or probably more something like this nowadays ;-)
	cat my-dsdt-image > /sys/firmware/acpi/tables/DSDT

As I said in my previous email, I'm already convinced that late-override
of ACPI table approach would be very interesting to investigate.
However, this cannot be taken lightly. A _lot_ of places in the kernel
depend on the ACPI and nothing has ever been done in the direction of
dynamic modification of the APCI tables. The implementation is likely to
be much bigger than the current 100 lines of patch.

That said, it should be possible to draw some assumptions without
restraining much the functionality. Such as:
 * every object present in the original table is still present is the
new table
 * they keep the same name

Len, do you think it would be feasible? How do you think the
implementation could be done?

Eric

