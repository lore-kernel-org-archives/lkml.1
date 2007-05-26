Return-Path: <linux-kernel-owner+w=401wt.eu-S1762101AbXEZQfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762101AbXEZQfe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbXEZQf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:35:27 -0400
Received: from www.osadl.org ([213.239.205.134]:48243 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752783AbXEZQf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:35:27 -0400
Subject: Re: [2.6.21.1] soft lockup when removing netconsole module
From: Thomas Gleixner <tglx@linutronix.de>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070526161645.GA11760@vanheusden.com>
References: <20070526154011.GB3735@vanheusden.com>
	 <465857DF.2020603@gmail.com> <1180195927.4264.11.camel@chaos>
	 <20070526161645.GA11760@vanheusden.com>
Content-Type: text/plain
Date: Sat, 26 May 2007 18:35:24 +0200
Message-Id: <1180197324.4264.23.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-26 at 18:17 +0200, Folkert van Heusden wrote:
> > > Seems to be hrtimers related - CC'ed Thomas.
> > I doubt that. The tick interrupt just finds out, that the machine is
> > stuck in rmmod.
> > > > Also the rmmod hangs and would not exit even with kill -9. It also
> > > > sucks up 100% cpu.
> > Can you please enable CONFIG_PROVE_LOCKING ?
>
> Luckily I already had :-)
> Here is its output:

So there is no output from lockdep, during the rmmod hang ? The rmmod
sucks 100% cpu, so it busy loops at some place. Looking at the stack
trace this seems to be in:


void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,                                                                                                                 
                                       struct delayed_work *dwork)                                                                                                                  
{                                                                                                                                                                                   
        while (!cancel_delayed_work(dwork))                                                                                                                                         
                flush_workqueue(wq);                                                                                                                                                
}

which is not really related to timers :)

	tglx


