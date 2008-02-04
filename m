Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbYBDW3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbYBDW3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 17:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbYBDW3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 17:29:05 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38006 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757316AbYBDW3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 17:29:04 -0500
Subject: Re: [rfc] direct IO submission and completion scalability issues
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, mingo@elte.hu,
       ak@suse.de, andrea@suse.de, clameter@sgi.com, akpm@linux-foundation.org,
       andrew.vasquez@qlogic.com, willy@linux.intel.com,
       Zach Brown <zach.brown@oracle.com>
In-Reply-To: <20080204103352.GD15220@kernel.dk>
References: <20070728012128.GB10033@linux-os.sc.intel.com>
	 <20080203095252.GA11043@wotan.suse.de> <20080204101243.GC15220@kernel.dk>
	 <20080204103135.GB15210@wotan.suse.de>  <20080204103352.GD15220@kernel.dk>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 16:28:55 -0600
Message-Id: <1202164135.3096.126.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-04 at 05:33 -0500, Jens Axboe wrote:
> As Andi mentions, we can look into making that lockless. For the initial
> implementation I didn't really care, just wanted something to play with
> that would nicely allow me to control both the submit and complete side
> of the affinity issue.

Sorry, late to the party ... it went to my steeleye address, not my
current one.

Could you try re-running the tests with a low queue depth (say around 8)
and the card interrupt bound to a single CPU.

The reason for asking you to do this is that it should emulate almost
precisely what you're looking for:  The submit path will be picked up in
the SCSI softirq where the queue gets run, so you should find that all
submit and returns happen on a single CPU, so everything gets cache hot
there.

James

p.s. if everyone could also update my email address to the
hansenpartnership one, the people at steeleye who monitor my old email
account would be grateful.

