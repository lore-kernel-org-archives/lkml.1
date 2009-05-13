Return-Path: <linux-kernel-owner+w=401wt.eu-S1758469AbZEMAQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbZEMAQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbZEMAQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:16:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:61055 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbZEMAQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:16:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TM32jj8pV1An0gxAophJoJmIQAjCGKis49Uqi3LLo4Nrib3otZmeofh+z9XQOQ6S7u
         vJSxu3mq3PagXqmMAO/wNX9Qg0cSCkDbX7yF/SqG42Rh4Db6LKbFDSddTFoBX+5WrGtr
         MvhRD3ge0gBjS0YdZXOzm67Ipd1brPG7mEzqE=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain>
	 <alpine.LFD.2.00.0904081937191.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain>
	 <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>
Date: Wed, 13 May 2009 12:16:09 +1200
Message-ID: <5a7b8b7b0905121716y646a2f68qad9181362caa22f6@mail.gmail.com>
Subject: Re: [Announce] 2.6.29.3-rt12
From: Hugo Vincent <hugo.vincent@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch resulted in a broken build for me, until I did this:

--- a/patch-2.6.29.3-rt12
+++ b/patch-2.6.29.3-rt12
@@ -121754,7 +121754,7 @@ Index: linux-2.6-tip/kernel/sched.c
  }

  /*
-@@ -2801,6 +3177,15 @@ static void update_cpu_load(struct rq *t
+@@ -2801,6 +3177,17 @@ static void update_cpu_load(struct rq *t
  			new_load += scale-1;
  		this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) >> i;
  	}
@@ -121765,8 +121765,10 @@ Index: linux-2.6-tip/kernel/sched.c
 +	this_rq->calc_load_update += LOAD_FREQ;
 +	calc_load_account_active(this_rq);
 +
++#ifdef CONFIG_SMP
 +	if (this_rq->cpu == calc_load_cpu)
 +		calc_global_load();
++#endif
  }

  #ifdef CONFIG_SMP

I have no idea if that is a valid thing to do, but it seems to work for me.

Regards,

Hugo Vincent

On Wed, May 13, 2009 at 11:27 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> We are pleased to announce the next update to our new preempt-rt
> series.
>
>    - rebase to 2.6.29.3 (NOP)
>    - loadavg optimization
>    - futex updates (tglx, peterz)
>
> Download locations:
>
>    http://rt.et.redhat.com/download/
>    http://www.kernel.org/pub/linux/kernel/projects/rt/
>
> Information on the RT patch can be found at:
>
>    http://rt.wiki.kernel.org/index.php/Main_Page
>
> to build the 2.6.29.3-rt12 tree, the following patches should be
> applied:
>
>    http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.29.3.tar.bz2
>    http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29.3-rt12.bz2
>
> The broken out patches are also available at the same download
> locations.
>
> Enjoy !
>
>       tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
