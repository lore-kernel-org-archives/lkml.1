Return-Path: <linux-kernel-owner+w=401wt.eu-S1763654AbXLMRLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763654AbXLMRLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbXLMRK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:10:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:62680 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbXLMRKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:10:55 -0500
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
From: Kay Sievers <kay.sievers@vrfy.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: vincent.fortier1@ec.gc.ca, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, maneesh@in.ibm.com
In-Reply-To: <20071213165059.GC4865@elte.hu>
References: <1197554397.19869.3.camel@lov.site>
	 <1197558120.4936.34.camel@kayak.wul.qc.ec.gc.ca>
	 <1197562981.19869.5.camel@lov.site>  <20071213165059.GC4865@elte.hu>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 18:10:42 +0100
Message-Id: <1197565842.19869.11.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/YqT6p/PsbbSttCMw0Wp1zIDwkK/jYolzJtlI
 9nSOONuZHnV+1MTvtOl55MxxVbzTdOVs1E7MbTV2zSfVDmF0Jq
 fIOYIgir+WFL3vhLWW1GWSxuxFw0DJb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-13 at 17:50 +0100, Ingo Molnar wrote:
> * Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > > > > > +   sa->attr.owner = NULL;
> > > > > >     sa->attr.name = name;
> > > > >
> > > > > i'm wondering why doesnt this affect 2.6.23 and later? Does sysfs
> > > > > initialize the owner field to NULL automatically?
> > > > 
> > > > Attibutes do not have an owner anymore:
> > > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7b595756ec1f49e0049a9e01a1298d53a7faaa15
> > > 
> > > This one also fails to apply properly at the exact same place has 
> > > Ingo's previously posted patch.  Would need to backport his one.
> > 
> > It depends on a completely reworked sysfs logic, I don't think it 
> > makes any sense to backport that.
> 
> well, if it fixes a live bug in a still supported stable kernel 
> release...
> 
> Vincent, could you try to just get rid of all actual uses of 
> se->attr.owner, within fs/sysfs/*.c? Something like the patch below. 
> (totally untested - might be fatally broken as well)

How can you think that this is not needed? You can not remove it with
sysfs you are patching. Hope this explains it:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0ab66088c855eca68513bdd7442a426c4b374ced

Kay

