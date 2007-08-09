Return-Path: <linux-kernel-owner+w=401wt.eu-S965127AbXHIFhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965127AbXHIFhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 01:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965013AbXHIFhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 01:37:05 -0400
Received: from gw.goop.org ([64.81.55.164]:43238 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965010AbXHIFhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 01:37:03 -0400
Message-ID: <46BAA799.7080806@goop.org>
Date: Wed, 08 Aug 2007 22:35:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <glommer@gmail.com>
CC: "Nakajima, Jun" <jun.nakajima@intel.com>, lguest@ozlabs.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       chrisw@sous-sol.org, anthony@codemonkey.ws, akpm@linux-foundation.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>, mingo@elte.hu
Subject: Re: Introducing paravirt_ops for x86_64
References: <11865467522495-git-send-email-gcosta@redhat.com>	<97D612E30E1F88419025B06CB4CF1BE10326E129@scsmsx412.amr.corp.intel.com> <5d6222a80708080758t1b937d0ej14c5e60ac23a20c5@mail.gmail.com>
In-Reply-To: <5d6222a80708080758t1b937d0ej14c5e60ac23a20c5@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> On 8/8/07, Nakajima, Jun <jun.nakajima@intel.com> wrote:
>   
>> Glauber de Oliveira Costa wrote:
>>     
>>> Hi folks,
>>>
>>> After some time away from it, and a big rebase as a consequence, here
>>>       
>> is
>>     
>>> the updated version of paravirt_ops for x86_64, heading to inclusion.
>>>
>>> Your criticism is of course, very welcome.
>>>
>>> Have fun
>>>       
>> Do you assume that the kernel ougtht to use 2MB pages for its mappings
>> (e.g. initilal text/data,  direct mapping of physical memory) under your
>> paravirt_ops?  As far as I look at the patches, I don't find one.
>>     
>
> I don't think how it could be relevant here. lguest kernel does use
> 2MB pages, and it goes smootly. For 2MB pages, we will update the page
> tables in the very same way, and in the very places we did before.
> Just that the operations can now be overwritten.
>
> So, unless I'm very wrong,  it only makes sense to talk about not
> supporting large pages in the guest level. But it is not a
> paravirt_ops problem.
>   

At the moment Xen can't support guests with 2M pages.  In 32-bit this
isn't a huge problem, since the kernel doesn't assume it can map itself
with 2M pages.  But I think the 64-bit kernel assumes 2M pages are
always available for mapping the kernel.  I don't know how pervasive
this assumption is, but it would be nice to parameterize it in pv-ops.


    J
