Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbYJMOfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbYJMOfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbYJMOe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:34:57 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:50899 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbYJMOe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:34:56 -0400
Date: Mon, 13 Oct 2008 15:34:09 +0100
From: Alan Swanson <swanson@ukfsn.org>
To: linux-kernel@vger.kernel.org
Subject: Binutils bug on not using NOPL with i686 needs persuasive arguments
Message-ID: <20081013143409.GA10924@zaphod.infiniteimprobability.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. (Usual not subscribed CC request.)

I need some heavyweight assistance with verifying and convincing the
binutils gas maintainer that using NOPL on i686 is undesirable and also
fixing it so that only march changes the NOP sequence used and not
mtune.

This was from from thread "[BUG] x86 kenel won't boot under Virtual PC"
where NOPL was deemed rather bad and a bug requested. I was
investigating a Geode miniitx motherboard and it was still an issue
with no bug was raised so did so.

http://marc.info/?l=linux-kernel&m=122090041613423&w=2
http://sourceware.org/bugzilla/show_bug.cgi?id=6957

MARCH VERSUS MTUNE
The bug was closed as works for me but the patch that was applied
doesn't seem to change anything in regards mtune versus march
selection, though the testcase result is correct. However I'm worried
it now means passing -march=i686 will start using NOPL and break
things that were conviently missed by gcc stripping the mtune option
passed to gas. Which leads to...

NO NOPL WITH I686
Though pretty unlikely and just being standards strict, as an Intel
employee there may be a possible self-interest and makes it harder
convincing him that that NOPL is undesirable with -march=i686 even
if an original standard. From comment 10 I don't see how using
f32_patt will prevent the assembler taking SSE instructions by
default but I don't have the knowledge to argue that point.

-- 
Thanks, Alan.
