Return-Path: <linux-kernel-owner+w=401wt.eu-S1161315AbXCNOnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161315AbXCNOnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 10:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161314AbXCNOnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 10:43:37 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:52249 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161311AbXCNOng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 10:43:36 -0400
Message-ID: <45F80A00.1080007@linux.vnet.ibm.com>
Date: Wed, 14 Mar 2007 20:13:12 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: balbir@in.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Kirill Korotaev <dev@sw.ru>,
       containers@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@sw.ru>,
       Dave Hansen <hansendc@us.ibm.com>
Subject: Re: [RFC][PATCH 4/7] RSS accounting hooks over the code
References: <45ED7DEC.7010403@sw.ru> <45ED81F2.80402@sw.ru>	<m14porwq1c.fsf@ebiederm.dsl.xmission.com> <45F57E7D.6080604@sw.ru>	<1173718208.11945.54.camel@localhost.localdomain>	<20070312235452.GB11578@MAIL.13thfloor.at>	<m1veh5sbwy.fsf@ebiederm.dsl.xmission.com>	<45F67C2D.7020303@yahoo.com.au> <m1odmxrv2l.fsf@ebiederm.dsl.xmission.com> <45F77149.7040604@yahoo.com.au> <45F7993E.2010200@in.ibm.com> <45F79CF3.1090302@yahoo.com.au> <45F7A8D3.3010109@in.ibm.com> <45F7F7B4.50100@linux.vnet.ibm.com> <45F7FD53.8000908@yahoo.com.au>
In-Reply-To: <45F7FD53.8000908@yahoo.com.au>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Nick Piggin wrote:
> Vaidyanathan Srinivasan wrote:
> 
>> Accounting becomes easy if we have a container pointer in struct page.
>>  This can form base ground for building controllers since any memory
>> related controller would be interested in tracking pages.  However we
>> still want to evaluate if we can build them without bloating the
>> struct page.  Pagecache controller (2) we can implement with container
>> pointer in struct page or container pointer in struct address space.
> 
> The thing is, you have to worry about actually getting anything in the
> kernel rather than trying to do fancy stuff.
> 
> The approaches I have seen that don't have a struct page pointer, do
> intrusive things like try to put hooks everywhere throughout the kernel
> where a userspace task can cause an allocation (and of course end up
> missing many, so they aren't secure anyway)... and basically just
> nasty stuff that will never get merged.
> 
> Struct page overhead really isn't bad. Sure, nobody who doesn't use
> containers will want to turn it on, but unless you're using a big PAE
> system you're actually unlikely to notice.
> 
> But again, I'll say the node-container approach of course does avoid
> this nicely (because we already can get the node from the page). So
> definitely that approach needs to be discredited before going with this
> one.

I agree :)

>> Building on this patchset is much simple and and we hope the bloat in
>> struct page will be compensated by the benefits in memory controllers
>> in terms of performance and simplicity.
>>
>> Adding too many controllers and accounting parameters to start with
>> will make the patch too big and complex.  As Balbir mentioned, we have
>> a plan and we shall add new control parameters in stages.
> 
> Everyone seems to have a plan ;) I don't read the containers list...
> does everyone still have *different* plans, or is any sort of consensus
> being reached?

Consensus?  I believe at this point we have a sort of consensus on the
base container infrastructure and the need for memory controller to
control RSS, pagecache, mlock, kernel memory etc.  However the
implementation and approach taken is still being discussed :)

--Vaidy

