Return-Path: <linux-kernel-owner+w=401wt.eu-S936877AbXLQXso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936877AbXLQXso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933457AbXLQXsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:48:30 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:43608 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933345AbXLQXs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:48:29 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18279.2719.394892.692343@stoffel.org>
Date: Mon, 17 Dec 2007 18:47:43 -0500
From: "John Stoffel" <john@stoffel.org>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, John Stoffel <john@stoffel.org>,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: 2.6.24-rc5: tape drive not responding
In-Reply-To: <1197928348.3204.14.camel@localhost.localdomain>
References: <18277.52079.718004.969358@stoffel.org>
	<20071217112551H.fujita.tomonori@lab.ntt.co.jp>
	<20071217031510.c3d500fd.akpm@linux-foundation.org>
	<18278.55130.471797.398922@stoffel.org>
	<18278.58314.892734.490418@stoffel.org>
	<20071217134344.3f024461.akpm@linux-foundation.org>
	<1197928348.3204.14.camel@localhost.localdomain>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@SteelEye.com> writes:

James> On Mon, 2007-12-17 at 13:43 -0800, Andrew Morton wrote:
>> On Mon, 17 Dec 2007 16:02:02 -0500
>> "John Stoffel" <john@stoffel.org> wrote:
>> 
>> > 
>> > Just to confirm, the propsed patch to st.c fixes the issue with
>> > 2.6.24-rc5 as well at 2.6.24-rc5-mm1 with access to my DLT tape
>> > drives.
>> 
>> err, what patch to st.c?

James> That's this one:

James> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=acdd0b1c371b2fbb4b6110a51ba69cb0af9e6f45

>> So it seems that 2.6.24 (and presumably 2.6.23?) need

James> Not 2.6.23 .. the scatterlist changes causing the st problems
James> are local to 2.6.24.

Correct, I ran 2.6.23 for 47+ days of uptime without any problems.  I
jumped to 2.6.24-rc5-mm1 to do my best to help out with finding
problems.  Happy to have found one.  :]

>> 1: Alan's "initio: fix conflict when loading driver" (currently stocuk
>> in git-scsi-misc)

James> Yes, I'm moving this into scsi-rc-fixes

I have nothing to do with this issue.

>> 2: Boaz's "initio: initio_build_scb() fix" (my name for it)

James> And applying this ... although I'd still appreciate confirmation from
James> someone that the initio driver works after this.

Sorry, I don't have of this hardware at all.

>> 3: The mystery st.c fix.
>> 
>> yes?

James> James

Here's the simple one liner patch for the st.c problem:

--- orig/drivers/scsi/st.c     2007-12-16 20:08:45.000000000
-0500
+++ patched/drivers/scsi/st.c   2007-12-17 13:55:30.000000000 -0500
@@ -3611,6 +3611,7 @@
 
        tb->dma = need_dma;
        tb->buffer_size = got;
+	sg_init_table(tb->sg, max_sg);
 
        return tb;
 }


Hopefully it's not whitespace damaged.

John
