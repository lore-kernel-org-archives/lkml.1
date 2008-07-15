Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbYGOTKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbYGOTKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbYGOTKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:10:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:24385 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbYGOTKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:10:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=V4lspz43dQy8l7kE2eUmebfJEyaDnuLIrAF7KkW/Jl7gShhxWOxhxLB3Qve0dLtXIE
         zQmAKcsP+WMLuhpYmKQqeGxH8AZ6uaVnBQar9+1l/bwfw7NZmHXv0/0oxZ9Q75XOldsa
         THlrRGSlLnzUe82VJBIMMHbL7z62FhskQ/ssw=
Message-ID: <86802c440807151210m37398d7es2e07f9d9b834363@mail.gmail.com>
Date: Tue, 15 Jul 2008 12:10:10 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Zachary Amsden" <zach@vmware.com>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too - fix
Cc: "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1216148658.6620.192.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216147130.6620.184.camel@bodhitayantram.eng.vmware.com>
	 <20080715185123.GA31445@linux-os.sc.intel.com>
	 <1216148658.6620.192.camel@bodhitayantram.eng.vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 12:04 PM, Zachary Amsden <zach@vmware.com> wrote:
> On Tue, 2008-07-15 at 11:51 -0700, Suresh Siddha wrote:
>> On Tue, Jul 15, 2008 at 11:38:50AM -0700, Zachary Amsden wrote:
>> >
>> > Nacked-by: Zachary Amsden <zach@vmware.com>
>> >
>> > What are you doing here and why aren't you cc-ing the maintainers?
>>
>> Sorry. I was about to bring you into the loop.
>>
>> Yinghai posted 32bit native apic_ops(similar to my 64bit apic ops patch, which
>> is different from pv_apic_ops) which is in tip/x86/x2apic and proposed a fix
>> for VMI case aswell.
>>
>> Based on my understanding, tip/x86/x2apic git commit
>> 94a8c3c2437c8946f1b6c8e0b2c560a7db8ed3c6 is wrong and it should be fixed with
>> something like
>> http://marc.info/?l=linux-kernel&m=121614328831237&w=2
>
> Looks better, but I need to read more context to find out where the
> apic_ops variable comes from; I'll read the list for patches.
>
> You are correct in that we will want to use the same wait_icr_idle
> routine as native hardware; it's not clear from just this patch how that
> happens.
>
> Also, the VMI operations are sensitive to parameter order because they
> interface with an ABI at the other end.  I need to check the parameter
> order for apic read / write is still consistent with the ABI.

http://people.redhat.com/mingo/tip.git/readme.txt

mkdir linux-2.6
cd linux-2.6

git init

git remote add linus
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

git remote add tip
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

git remote update

git checkout -b tip-latest tip/master

git merge tip/x86/x2apic

YH
