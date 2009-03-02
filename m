Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbZCBAms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbZCBAms (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 19:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbZCBAmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 19:42:39 -0500
Received: from gw.goop.org ([64.81.55.164]:44372 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770AbZCBAmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 19:42:38 -0500
Message-ID: <49AB2B7B.2000103@goop.org>
Date: Sun, 01 Mar 2009 16:42:35 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>	<20090227212812.26d02f34.akpm@linux-foundation.org>	<49A8DF28.4050301@goop.org> <87eixi35ew.fsf@basil.nowhere.org> <49AB1B75.2060200@goop.org> <49AB1FB8.607@zytor.com> <49AB2387.8040002@goop.org> <49AB24E0.5020604@zytor.com>
In-Reply-To: <49AB24E0.5020604@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>> H. Peter Anvin wrote:
>>> In this particular case, this is actually false.  "No PAT" in the 
>>> processor is *not* the same thing as "no cacheability controls in 
>>> the page tables".  Every processor since the 386 has had UC, WT, and 
>>> WB controls in the page tables; PAT only added the ability to do WC 
>>> (and WP, which we don't use).  Since the number of processors which 
>>> can do WC at all but don't have PAT is a small set of increasingly 
>>> obsolete processors, we may very well choose to simply ignore the WC 
>>> capabilities of these particular processors. 
>>
>> I'm not quite sure what you're referring to with "this is actually 
>> false".  Certainly we support cachability control in ptes under Xen.  
>> We just don't support full PAT because Xen uses PAT for itself.
>>
>
> What do you define as "full PAT"?  If what you mean is that Xen lays 
> claims to the PAT MSR and only allows a certain mapping that's hardly 
> a problem... other than that it's not an exhaustible resource so I 
> guess I really don't understand what you're trying to say here.

It does not allow guests to set their own PAT MSRs.  It can't easily be 
multiplexed either, as all CPUs must have the same settings for their 
PAT MSRs.  I guess it could be handled by allowing domains to set their 
own virtual PAT MSRs, and then rewriting the ptes to convert from the 
guest PAT settings to Xen's, but I don't know if this is possible in 
general (and it poses some problems because the pte modifications would 
be guest-visible).

    J
