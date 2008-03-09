Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbYCISrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbYCISrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 14:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYCISrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 14:47:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbYCISrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 14:47:11 -0400
Date: Sun, 9 Mar 2008 11:46:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
Message-Id: <20080309114640.85c9c3eb.akpm@linux-foundation.org>
In-Reply-To: <20080309123432.GA3267@elte.hu>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
	<20080309111456.GA21690@elte.hu>
	<20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080309120940.GA1695@elte.hu>
	<20080309123432.GA3267@elte.hu>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008 13:34:32 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> the right solution is to get rid of quicklists altogether

Yes, I think so.

- They are pretty marginal from a performance POV (iirc)

- They've been a relatively rich source of bugs

- As I said when we merged them (under protest): Private object caches
  like this are just a bad idea - caches should be *shared*, because some
  other code path which wants a zeroed page wants a cache-warm one, not a
  cache-cold one from the allocator (iirc there was doubt over how
  cache-warm these pages are, however).

  Making __GFP_ZERO smarter/more efficient would be a preferable way of
  addressing any performance problems we have in there.
