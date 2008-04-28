Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbYD1MNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbYD1MNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 08:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765374AbYD1MNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 08:13:11 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38716 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765110AbYD1MNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 08:13:09 -0400
Subject: Re: [GIT PATCH] another tranche of SCSI updates for 2.6.26
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48157B6A.60307@panasas.com>
References: <1209320076.3801.26.camel@localhost.localdomain>
	 <20080428013400.GA6245@elte.hu>
	 <1209351113.3801.107.camel@localhost.localdomain>
	 <48157B6A.60307@panasas.com>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 08:13:03 -0400
Message-Id: <1209384784.3367.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-28 at 10:23 +0300, Boaz Harrosh wrote:
> If we are already on the subject. It looks like we always have at most 1 command in the 
> free list, so why the free list at all? or am I reading the code wrong?

Because list handlers are well understood mechanisms within the kernel.
Also because in low memory situations, one command per host is
sufficient to guarantee forward progress, but it's not going to be very
efficient.  Embedded and other low memory environments can increase the
size of the free list to improve their I/O path.

James


