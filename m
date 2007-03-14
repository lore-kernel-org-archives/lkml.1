Return-Path: <linux-kernel-owner+w=401wt.eu-S1030851AbXCNNtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030851AbXCNNtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 09:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030852AbXCNNtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 09:49:20 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:38093 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030851AbXCNNtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 09:49:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=S7S2vQnieCgOoRTJ40L84vMGrDnJHtPMf5jSfsqEqTVrN+5MryG9sfaNHWEBge2ZE98uaIc7sW12j16NJB6a0k02nkJyuDC75mg216n8ZXNXBGip0AkfZ1u0tCGXx8obIK6hrcglyekDgHPUlI1jaxYeJJJMBGeNFRRzJ5E+jIE=  ;
X-YMail-OSG: uDJupXoVM1n.aRcbGDoPo8tjuI8fHsEe_LasQ3gtAiSMNhrjNjPHm..AEHtalQjSVddn25llD00Hn1Hmcgu1asX2OGpY9ERCOAJq3oExDrOz.YCKZyWqMFuvvCI6SZ96rKPM2e5Fiy1AfPw-
Message-ID: <45F7FD53.8000908@yahoo.com.au>
Date: Thu, 15 Mar 2007 00:49:07 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
CC: balbir@in.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Kirill Korotaev <dev@sw.ru>,
       containers@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@sw.ru>,
       Dave Hansen <hansendc@us.ibm.com>
Subject: Re: [RFC][PATCH 4/7] RSS accounting hooks over the code
References: <45ED7DEC.7010403@sw.ru> <45ED81F2.80402@sw.ru>	<m14porwq1c.fsf@ebiederm.dsl.xmission.com> <45F57E7D.6080604@sw.ru>	<1173718208.11945.54.camel@localhost.localdomain>	<20070312235452.GB11578@MAIL.13thfloor.at>	<m1veh5sbwy.fsf@ebiederm.dsl.xmission.com>	<45F67C2D.7020303@yahoo.com.au> <m1odmxrv2l.fsf@ebiederm.dsl.xmission.com> <45F77149.7040604@yahoo.com.au> <45F7993E.2010200@in.ibm.com> <45F79CF3.1090302@yahoo.com.au> <45F7A8D3.3010109@in.ibm.com> <45F7F7B4.50100@linux.vnet.ibm.com>
In-Reply-To: <45F7F7B4.50100@linux.vnet.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vaidyanathan Srinivasan wrote:

> Accounting becomes easy if we have a container pointer in struct page.
>  This can form base ground for building controllers since any memory
> related controller would be interested in tracking pages.  However we
> still want to evaluate if we can build them without bloating the
> struct page.  Pagecache controller (2) we can implement with container
> pointer in struct page or container pointer in struct address space.

The thing is, you have to worry about actually getting anything in the
kernel rather than trying to do fancy stuff.

The approaches I have seen that don't have a struct page pointer, do
intrusive things like try to put hooks everywhere throughout the kernel
where a userspace task can cause an allocation (and of course end up
missing many, so they aren't secure anyway)... and basically just
nasty stuff that will never get merged.

Struct page overhead really isn't bad. Sure, nobody who doesn't use
containers will want to turn it on, but unless you're using a big PAE
system you're actually unlikely to notice.

But again, I'll say the node-container approach of course does avoid
this nicely (because we already can get the node from the page). So
definitely that approach needs to be discredited before going with this
one.

> Building on this patchset is much simple and and we hope the bloat in
> struct page will be compensated by the benefits in memory controllers
> in terms of performance and simplicity.
> 
> Adding too many controllers and accounting parameters to start with
> will make the patch too big and complex.  As Balbir mentioned, we have
> a plan and we shall add new control parameters in stages.

Everyone seems to have a plan ;) I don't read the containers list...
does everyone still have *different* plans, or is any sort of consensus
being reached?

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
