Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbXLMNoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbXLMNoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 08:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbXLMNoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 08:44:05 -0500
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:45168 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753627AbXLMNoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 08:44:03 -0500
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
From: Vincent Fortier <vincent.fortier1@ec.gc.ca>
Reply-To: vincent.fortier1@ec.gc.ca
To: Ingo Molnar <mingo@elte.hu>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, Greg KH <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, kay.sievers@vrfy.org,
       Balbir Singh <balbir@in.ibm.com>, maneesh@in.ibm.com
In-Reply-To: <20071213131242.GD28340@elte.hu>
References: <20071211182528.GA5597@linux.vnet.ibm.com>
	 <F1D642E5A91BC94D9504EC83AE19E6B0015201F1@ecqcmtlmail3.quebec.int.ec.gc.ca>
	 <20071211210653.GA6902@elte.hu> <20071212070816.GA31455@linux.vnet.ibm.com>
	 <F1D642E5A91BC94D9504EC83AE19E6B0015201F6@ecqcmtlmail3.quebec.int.ec.gc.ca>
	 <20071212134158.GA5547@linux.vnet.ibm.com>
	 <F1D642E5A91BC94D9504EC83AE19E6B00152021F@ecqcmtlmail3.quebec.int.ec.gc.ca>
	 <20071213114336.GA5400@linux.vnet.ibm.com> <20071213125509.GA28340@elte.hu>
	 <20071213130231.GB16905@linux.vnet.ibm.com>
	 <20071213131242.GD28340@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Environnement Canada
Date: Thu, 13 Dec 2007 13:43:41 +0000
Message-Id: <1197553421.4936.6.camel@kayak.wul.qc.ec.gc.ca>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
X-OriginalArrivalTime: 13 Dec 2007 13:43:42.0189 (UTC) FILETIME=[2C8911D0:01C83D8E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-13 at 08:12 -0500, Ingo Molnar wrote:
> 
> * Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> 
> > > >  static void user_attr_init(struct subsys_attribute *sa, char
> *name, int mode)
> > > >  {
> > > > + sa->attr.owner = NULL;
> > > >   sa->attr.name = name;
> > >
> > > i'm wondering why doesnt this affect 2.6.23 and later? Does sysfs
> > > initialize the owner field to NULL automatically?
> > >
> >
> > Going through git log, it seems that commit
> > 7b595756ec1f49e0049a9e01a1298d53a7faaa15 deemed attribute->owner as
> > unnecessary. I guess that answers the question.
> 
> thx. The only open question seems to be: Vincent had sysfs crashes
> without the CFS patchset as well.
> 
> Wouldnt it be prudent to backport the core bits of the above commit
> (attached below), to make sure the owner field is never utilized.
> (because it seems it's so easy and common to not maintain it properly)
> 
> Vincent, does the patch below resolve the non-CFS crashes?

I was about to test but it does not apply on a 2.6.22:
[root@printemps linux-2.6.22.15-rc1-patched]# patch -p1
< ../make_sure_owner_field_is_never_utilized.patch
patching file fs/sysfs/bin.c
Hunk #1 FAILED at 175.
Hunk #2 FAILED at 198.
Hunk #3 FAILED at 207.
3 out of 3 hunks FAILED -- saving rejects to file fs/sysfs/bin.c.rej
patching file fs/sysfs/file.c
Hunk #1 FAILED at 241.
Hunk #2 FAILED at 250.
Hunk #3 FAILED at 266.
Hunk #4 FAILED at 274.
Hunk #5 FAILED at 283.
Hunk #6 FAILED at 292.
Hunk #7 FAILED at 304.
Hunk #8 FAILED at 312.
8 out of 8 hunks FAILED -- saving rejects to file fs/sysfs/file.c.rej

I was about to backport it but I find it's not that trivial...  Help
would be appreciated.

- vin
