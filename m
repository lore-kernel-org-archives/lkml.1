Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbYGQAt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbYGQAt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 20:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760253AbYGQAtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 20:49:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:28746 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760544AbYGQAtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 20:49:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Y5pzmfjhIY05sbqIJJwN8eUfsE+tdExr23C2Kxn1TGG5jYS260wIv4VqEYIGGJghY6
         ZY1XHoLlcQyCn/6FS1mNg3/5lR+a72Afs2O0yMkaGyIGZ/5CVRQXHahaDn4uZzWwPURe
         0O0royGcdec0LQ0K7dNgWJDQBbIKdmSjLkCr0=
Message-ID: <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com>
Date: Wed, 16 Jul 2008 17:49:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
In-Reply-To: <20080717004004.GA17792@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080716012427.GA27398@bromo.msbb.uc.edu>
	 <20080716035830.GA27935@bromo.msbb.uc.edu>
	 <dd18b0c30807152230u39ef9c18v78b48d1c7b9ddd17@mail.gmail.com>
	 <86802c440807160044ge504cacl419b6cbcad5f0f9d@mail.gmail.com>
	 <dd18b0c30807160050r5b10908fiffc2a4b464abe5f3@mail.gmail.com>
	 <86802c440807160136m6af981b2u6a37cabb8e33a629@mail.gmail.com>
	 <20080716140810.GA2861@bromo.msbb.uc.edu>
	 <86802c440807161029n7e0dac98x1ec260879204b6f0@mail.gmail.com>
	 <86802c440807161535n3a4d6891n6f7c16bd4e1f19c3@mail.gmail.com>
	 <20080717004004.GA17792@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 5:40 PM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> On Wed, Jul 16, 2008 at 03:35:17PM -0700, Yinghai Lu wrote:
>> please check latest linus tree.
>>
>> the commit could be related.
>>
>> commit c91d924e3af08d4f98eab6ebf81f2b8ce132448f
>> Author: Bob Moore <robert.moore@intel.com>
>> Date:   Tue Jun 10 12:38:10 2008 +0800
>>
>>     ACPICA: Fix for hang on GPE method invocation
>>
>>     Fixes problem where the new method argument count validation mechanism
>>     will enter an infinite loop when a GPE method is dispatched.
>>     Problem fixed be removing the obsolete code that passes GPE block
>>     information to the notify handler via the control method parameter pointer.
>>
>> YH
>
> Yinghai,
>   The latest linus tree doesn't eliminate the hangs in 2.6.26 with your
> mmconfig patch. Also, I've been unable to repeat the boot with pci=noacpi using
> the mmconfig patch under 2.6.26. I've uploaded a dmesg file though from
> the 2.6.25.10 kernel booted with apic=verbose in case that sheds any light
> on these problems.
>
> http://bugzilla.kernel.org/show_bug.cgi?id=11087
>
> Also, I assume you meant earlier that is bad that with your mmconfig patch
> that I only see 0 - 63 buses. Any idea how we might fix that (in case it
> is related to the hang)?

please boot with
debug initcall_debug apic=verbose pci=routeirq?

and try pci=nommconf

I suspect that could be pci bridge is using 0xf0000000-0xf400000 too
after Linus merge pci tree, please try to boot with
pci=early_config_dump
to see if it is true.

please don't drop the cc list.

YH
