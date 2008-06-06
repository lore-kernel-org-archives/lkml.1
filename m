Return-Path: <linux-kernel-owner+w=401wt.eu-S933071AbYFFVFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbYFFVFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932175AbYFFVEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:04:52 -0400
Received: from deep2.securesites.net ([198.65.247.173]:1177 "EHLO
	deep2.securesites.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759785AbYFFVEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:04:51 -0400
X-Greylist: delayed 1324 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jun 2008 17:04:49 EDT
Date: Fri, 6 Jun 2008 14:47:04 -0600
From: Scott Wiersdorf <scott@bluehost.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, matt@bluehost.com
Subject: Re: [PATCH 2.6.25-4] getdelays.c: signal handling for log rotation
Message-ID: <20080606204704.GA4330@perlcode.org>
References: <20080605194334.GA56830@perlcode.org> <87d4muu0k2.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d4muu0k2.fsf@basil.nowhere.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 03:59:09PM +0200, Andi Kleen wrote:
> Scott Wiersdorf <scott@perlcode.org> writes:
> 
> > This adds a USR1 signal handler to getdelays.c, which causes getdelays
> > to close its logfile and reopen it (if '-w logfile' is
> > specified). This is useful in situations when getdelays is running for
> > a long time (i.e, the log file growing) and you need to rotate the
> > logs but don't want to lose any log data.
> 
> You could do the same by sending SIGSTOP; copy file; truncate file; SIGCONT

Actually, I was wrong in my previous reply. Sorry for my error. The
above will work fine (no data loss; I guess the data queues somewhere
in some magic way?)

I still think a single handler is elegant enough though, and works
better with many log rotation systems that want to send a single
signal to a pid (it's what we need where I'm working now, hence the
patch).

Scott
-- 
Scott Wiersdorf
<scott@bluehost.com>
