Return-Path: <linux-kernel-owner+w=401wt.eu-S932239AbYEGH04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbYEGH04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758963AbYEGH0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:26:45 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:13769 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbYEGH0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:26:43 -0400
Message-Id: <482175EF.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 07 May 2008 08:27:11 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <odie@cs.aau.dk>, "Ingo Molnar" <mingo@elte.hu>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <tglx@linutronix.de>,
       "Chuck Ebbert" <cebbert@redhat.com>, <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Please revert 709f744 (x86: bitops asm constraint fixes)
References: <1209995129.5172.19.camel@odie.local>
 <20080506120155.GG32591@elte.hu>
In-Reply-To: <20080506120155.GG32591@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 06.05.08 14:01 >>>
>
>* Simon Holm Thøgersen <odie@cs.aau.dk> wrote:
>
>> [CC'ing all that commented on the patch on LKML]
>> 
>> 709f744 causes my computer to freeze during the start up of X and my 
>> login manger (GDM). It gets to the point where it has shown the 
>> default X mouse cursor logo (a big X / cross) and does not respond to 
>> anything from that point on.
>> 
>> This worked fine before 709f744, and it works fine with ﻿709f744 
>> reverted on top of Linus' current tree (f74d505). The revert had 
>> conflicts, as far as I can tell due to white space changes. The diff I 
>> ended up with is below.
>> 
>> It is 100% reproducible.
>
>thanks Simon for tracking this down.
>
>I've applied your revert (see the patch below), we'll do it unless the 
>real bug is found and confirmed by you. What exact compiler version are 
>you using to build the kernel?
>
>Jan, any ideas what's wrong with your commit?

No, I have no idea at all (apart from considering mis-compilation as you
did. The best path I could suggest is to try and nail this down to one
(or more, if that happens to be the case) function(s) having been
changed - this is mostly because part of the changes are really
tightening things (which therefore I would think ought to be kept),
while the change to __test_and_change_bit() really weakens things
(which I nevertheless continue to think is correct and consistent with
other functions, but which then would be the primary suspect). Of
course, since no-one else has seen this so far, this would need to be
done by Simon.
Once down to a single (hopefully) function, it might be possible to just
statically compare the two vmlinux-es to perhaps spot whether this
indeed is mis-compilation.

Jan
