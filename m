Return-Path: <linux-kernel-owner+w=401wt.eu-S1764034AbYBZRpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764034AbYBZRpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763983AbYBZRow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:44:52 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762393AbYBZRos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:44:48 -0500
Date: Tue, 26 Feb 2008 09:43:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Nick Cheng <nick.cheng@areca.com.tw>, Erich Chen <erich@areca.com.tw>,
       kopi@linuxbox.cz
Subject: Re: arcmsr & areca-1660 - strange behaviour under heavy load
Message-Id: <20080226094308.35db8f3f.akpm@linux-foundation.org>
In-Reply-To: <alpine.LRH.0.9999.0802261032440.31781@linuxbox.linuxbox.cz>
References: <alpine.LRH.0.9999.0802231201380.21313@linuxbox.linuxbox.cz>
	<20080224161034.f494fc7f.akpm@linux-foundation.org>
	<alpine.LRH.0.9999.0802261032440.31781@linuxbox.linuxbox.cz>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 10:35:31 +0100 (CET) Nikola Ciprich <extmaillist@linuxbox.cz> wrote:

> Hi
> 
> On Sun, 24 Feb 2008, Andrew Morton wrote:
> 
> Hi Andrew,
> thanks a lot for reply, I'm attaching requested information.
> please let me know if You need more information/testing, whatever.
> I'll be glad to help.
> BR
> nik
> 
> >> Areca support doesn't seem to be very interested in the problem :-(
> >
> > (cc's added)
> >
> > Please get the machine into this state of memory exhaustion then take
> > copies of the output of the following, and send them via reply-to-all to
> > this email:
> >
> > - cat /proc/meminfo
> >
> > - cat /proc/slabinfo
> >
> > - dmesg -c > /dev/null ; echo m > /proc/sysrq-trigger ; dmesg -c
> >
> > Thanks.

Alas, that all looks OK to me.

You never get any out-of-memory messages, and no oom-killing messages?

Possibly what is happening here is that in this low-memory condition, some
of the driver's internal memory-allocation attempts are failing, and the
driver isn't correctly handling this.  This is a rare situation which may
well not have been hit in anyone else's testing.

I expect that the Areca engineers will be able to reproduce this with a
suitably small "mem=" kernel boot option.  If not, they could perhaps
investigate the kernel's fault-injection framework, which permits
simulation of page allocation failures.
