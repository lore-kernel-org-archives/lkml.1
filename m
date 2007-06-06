Return-Path: <linux-kernel-owner+w=401wt.eu-S932291AbXFFRkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbXFFRkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbXFFRk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:40:28 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53617 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbXFFRk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:40:27 -0400
Subject: Re: [PATCH -rt] Fix TASKLET_STATE_SCHED WARN_ON()
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070606094548.GA9511@elte.hu>
References: <1181096244.6018.20.camel@localhost>
	 <20070606094548.GA9511@elte.hu>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 10:39:55 -0700
Message-Id: <1181151595.6275.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 11:45 +0200, Ingo Molnar wrote:
> * john stultz <johnstul@us.ibm.com> wrote:
> 
> > This fix avoids this race by making sure *after* we've locked the 
> > tasklet that the STATE_SCHED bit is set before adding it to the list.
> > 
> > Does it look ok to you?
> 
> ah - nice!! What would be the worst-case effect of this bug? (besides 
> the WARN_ON()?) In any case, this fix will be in -rt10. Great work!

The only side effect I can come up w/ is you might run a tasklet 3 times
if it was only scheduled twice.

thanks
-john

