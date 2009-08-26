Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbZHZVcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbZHZVcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbZHZVcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:32:14 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:64077 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbZHZVcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FjaIz//ATGlPZ0oNHlnruSeuyUQS+7slrbnyjHM5MOM6nZmzz+TYZnA4/L2otxUFCg
         zA5rT+7fdt2Avxe/ZEPgDmy+Ats8cjraJMy+6AGWRykH4uRjco3rzSpDOfr5DqeW5qbe
         vzwUHqMMSh22cnSpz6j7NgjdlqfUcR8tzJ5EM=
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: raz ben yehuda <raziebe@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>, Mike Galbraith <efault@gmx.de>,
       riel@redhat.com, andrew motron <akpm@linux-foundation.org>,
       wiseman@macs.biu.ac.il, lkml <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org
In-Reply-To: <20090826193252.GA14721@elte.hu>
References: <1251282598.3514.20.camel@raz>
	 <alpine.DEB.1.10.0908260943090.9924@gentwo.org>
	 <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz>
	 <1251300625.18584.18.camel@twins>
	 <alpine.DEB.1.10.0908261136590.9933@gentwo.org>
	 <1251302598.18584.31.camel@twins>
	 <alpine.DEB.1.10.0908261211340.9933@gentwo.org>
	 <20090826180407.GA13632@elte.hu>
	 <alpine.DEB.1.10.0908261509580.9933@gentwo.org>
	 <20090826193252.GA14721@elte.hu>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 00:32:09 +0300
Message-Id: <1251322329.3882.42.camel@raz>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Hello 
First thank you for your interest.

OFFSCHED is a variant of a proprietary software. it is 4 years old.It is
stable. and.. well...this thing works .And it is so simple. SO VERY VERY
SIMPLE. ONCE YOU GO OFFLINE YOU NEVER LOOK BACK. 

OFFSCHED has a full access to many kernel facilities. My software
transmits packets, encrypt packets, and reaches network throughput
traffic ( 25Gbs), same as pktgen while saturating its 8 SSD disks.

My software take statistics of an offloaded processor usage, and unlike
OS processors, since I have a full control of the processor, the usage
is growing quite linearly. there are no bursts of CPU usage. it remains
stable of X% usage even when I transmit 25Gbps.

OFFSCHED __oldest__ patch was 4 lines. this how it started. 4 lines of
patch and My 2.6.18-8.el5 kernel is suddenly a hard real time kernel.
Today, I patch this kernel, build only a bzImage, throw this 2MB bzImage
on a server running regular centos/redhat distribution, and caboom, I
have a real time server in god-know-where. I do not mess with any
driver, i do not mess with initrd. I just fix 4 lines. that all.

OFFSCHED is not just for real time. It can monitor the kernel, protect
it and do whatever come to mind. please see OFFSCHED-RTOP.pdf. 

thank you
raz

 
On Wed, 2009-08-26 at 21:32 +0200, Ingo aMolnar wrote:
> * Christoph Lameter <cl@linux-foundation.org> wrote:
> 
> > On Wed, 26 Aug 2009, Ingo Molnar wrote:
> > 
> > > The thing is, you have cut out (and have not replied to) this
> > > crutial bit of what Peter wrote:
> > >
> > > > > The past year or so you've been whining about the tick latency,
> > > > > and I've seen exactly _0_ patches from you slimming down the
> > > > > work done in there, even though I pointed out some obvious
> > > > > things that could be done.
> > >
> > > ... which pretty much settles the issue as far as i'm concerned. 
> > > If you were truly interested in a constructive solution to lower 
> > > latencies in Linux you should have sent patches already for the 
> > > low hanging fruits Peter pointed out.
> > 
> > The noise latencies were already reduced in years earlier to the 
> > mininum (f.e. the work on slab queue cleaning). Certainly more 
> > could be done there but that misses the point.
> 
> Peter suggested various improvements to the timer tick related 
> latencies _you_ were complaining about earlier this year. Those 
> latencies sure were not addressed 'years earlier'.
> 
> If you are unwilling to reduce the very latencies you apparently 
> cared and complained about then you dont have much real standing to 
> complain now.
> 
> ( If you on the other hand were approaching this issue with 
>   pragmatism and with intellectual honesty, if you were at the end 
>   of a string of patches that gradually improved latencies but 
>   couldnt get them below a certain threshold, and if scheduler 
>   developers couldnt give you any ideas what else to improve, and 
>   _then_ suggested some other solution, you might have a point.
>   You are far away from being able to claim that. )
> 
> Really, it's a straightforward application of Occam's Razor to the 
> scheduler. We go for the simplest solution first, and try to help 
> more people first, before going for some specialist hack.
> 
> > The point of the OFFLINE scheduler is to completely eliminate the 
> > OS disturbances by getting rid of *all* OS processing on some 
> > cpus.
> > 
> > For some reason scheduler developers seem to be threatened by this 
> > idea and they go into bizarre lines of arguments to avoid the 
> > issue. Its simple and doable and the scheduler will still be there 
> > after we do this.
> 
> If you meant to include me in that summary categorization, i dont 
> feel 'threatened' by any such patches (why would i? They dont seem 
> to have sharp teeth nor any apparent poison fangs) - i simply concur 
> with the reasons Peter listed that it is a technically inferior 
> solution.
> 
> 	Ingo

