Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbZKQRaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbZKQRaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbZKQRaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:30:05 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:25180 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbZKQRaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:30:04 -0500
Subject: Re: [RFC] Block IO Controller V2 - some results
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
In-Reply-To: <20091117164026.GE22462@redhat.com>
References: <1258404660.3533.150.camel@cail>
	 <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail>
	 <20091117141411.GA22462@redhat.com>
	 <4e5e476b0911170817s39286103g3796f25cba9f623c@mail.gmail.com>
	 <20091117164026.GE22462@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 12:30:07 -0500
Message-ID: <1258479007.6084.162.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 11:40 -0500, Vivek Goyal wrote:
> On Tue, Nov 17, 2009 at 05:17:53PM +0100, Corrado Zoccolo wrote:
> > Hi Vivek,
> > the performance drop reported by Alan was my main concern about your
> > approach. Probably you should mention/document somewhere that when the
> > number of groups is too large, there is large decrease in random read
> > performance.
> > 
> 
> Hi Corrodo,
> 
> I thought more about it. We idle on sync-noidle group only in case of 
> rotational media not supporting NCQ (hw_tag = 0). So for all the fast
> hardware out there (SSD and fast arrays), we should not be idling on 
> sync-noidle group hence should not additional idling per group.
> 
> This is all subjected to the fact that we have done a good job in
> detecting the queue depth and have updated hw_tag accordingly.
> 
> On slower rotational hardware, where we will actually do idling on
> sync-noidle per group, idling can infact help you because it will reduce
> the number of seeks (As it does on my locally connected SATA disk).
> 
> > However, we can check few things:
> > * is this kernel built with HZ < 1000? The smallest idle CFQ will do
> > is given by 2/HZ, so running with a small HZ will increase the impact
> > of idling.
> > 
> > On Tue, Nov 17, 2009 at 3:14 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > Regarding the reduced throughput for random IO case, ideally we should not
> > > idle on sync-noidle group on this hardware as this seems to be a fast NCQ
> > > supporting hardware. But I guess we might not be detecting the queue depth
> > > properly which leads to idling on per group sync-noidle workload and
> > > forces the queue depth to be 1.
> > 
> > * This can be ruled out testing my NCQ detection fix patch
> > (http://groups.google.com/group/linux.kernel/browse_thread/thread/3b62f0665f0912b6/34ec9456c7da1bb7?lnk=raot)
> 
> This will be a good patch to test here. Alan, can you also apply this
> patch and see if we see any improvement.

Vivek: Do you want me to move this over to the V3 version & apply this
patch, or stick w/ V2?

Thanks,
Alan

