Return-Path: <linux-kernel-owner+w=401wt.eu-S1762867AbXLMQZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762867AbXLMQZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762974AbXLMQYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:24:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59090 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762932AbXLMQYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:24:33 -0500
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
From: Kay Sievers <kay.sievers@vrfy.org>
To: vincent.fortier1@ec.gc.ca
Cc: Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, maneesh@in.ibm.com
In-Reply-To: <1197558120.4936.34.camel@kayak.wul.qc.ec.gc.ca>
References: <1197554397.19869.3.camel@lov.site>
	 <1197558120.4936.34.camel@kayak.wul.qc.ec.gc.ca>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 17:23:01 +0100
Message-Id: <1197562981.19869.5.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/z3Gy7LiPHRaqAr/+EsQGzwUacZh5ihDHsBNp
 PAGo4f3WPJ7iHE5iC3eAVucG0pard10DZB9tJOqm8lZuZWzGPv
 CrTFRN8elrURyYuQZ9N9Ov4a26M0MbR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-13 at 15:02 +0000, Vincent Fortier wrote:
> On Thu, 2007-12-13 at 08:59 -0500, Kay Sievers wrote:
> > On Thu, 2007-12-13 at 13:55 +0100, Ingo Molnar wrote:
> > > * Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > >
> > > > Could you please see if the following patch removes the oops due
> > to
> > > > CFS sysfs files? (There might still be the other oops due to the
> > > > floppy sysfs files)
> > > >
> > > > Ingo, could you please add this patch in your CFS backport to
> > 2.6.22
> > > > and older kernels?
> > >
> > > sure - i've updated the backport patches with this fix.
> > >
> > > >  static void user_attr_init(struct subsys_attribute *sa, char
> > *name, int mode)
> > > >  {
> > > > +   sa->attr.owner = NULL;
> > > >     sa->attr.name = name;
> > >
> > > i'm wondering why doesnt this affect 2.6.23 and later? Does sysfs
> > > initialize the owner field to NULL automatically?
> > 
> > Attibutes do not have an owner anymore:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7b595756ec1f49e0049a9e01a1298d53a7faaa15
> 
> This one also fails to apply properly at the exact same place has Ingo's
> previously posted patch.  Would need to backport his one.

It depends on a completely reworked sysfs logic, I don't think it makes
any sense to backport that.

Kay

