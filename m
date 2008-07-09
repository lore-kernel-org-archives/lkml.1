Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbYGIA2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbYGIA2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 20:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYGIA2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 20:28:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:21370 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbYGIA2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 20:28:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uT2na2sYe4vo8krcnEfR7TRWRFIn7k5Oo9mVkDwmD8c4xfmyN2kgvIudur8wlofAw3
         xIDiEAlgDqO7kk4ClORPii7krTncRhQP7lNbHs/ACNXXkHWoPNw8mWQOeMcJWdq1jGVQ
         i7ZGBcsbaBmPqX/tFRmACTPH48HUYUdkyKgTA=
Message-ID: <919fe2b30807081728n1ce1d0eckf1172386c22a0cf7@mail.gmail.com>
Date: Tue, 8 Jul 2008 20:28:07 -0400
From: "Mark Asselstine" <asselsm@gmail.com>
To: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: [PATCH] drm_memory.h: remove double inclusion of linux/vmalloc.h
Cc: "Ian Romanick" <ianr@q7.com>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, kernel-janitors@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <a4423d670807080956m4aa548b7vf5557892aae81432@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670807060431w639f0b1ajcbad6471d50ef802@mail.gmail.com>
	 <919fe2b30807080529j71ae1816sc035c90b5eee555c@mail.gmail.com>
	 <20080708152225.GA9028@q7.q7.com>
	 <a4423d670807080956m4aa548b7vf5557892aae81432@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2008 at 12:56 PM, Alexander Beregalov
<a.beregalov@gmail.com> wrote:
> 2008/7/8 Ian Romanick <ianr@q7.com>:
>> On Tue, Jul 08, 2008 at 08:29:57AM -0400, Mark Asselstine wrote:
>>> On Sun, Jul 6, 2008 at 7:31 AM, Alexander Beregalov
>>> <a.beregalov@gmail.com> wrote:
>>> > From: Alexander Beregalov <a.beregalov@gmail.com>
>>> >
>>> >  #if __OS_HAS_AGP
>>> >
>>> > -#include <linux/vmalloc.h>
>>> > -
>>>
>>> Why remove this one and not the one at the top of the file? As well
>>
>> I would assume this one is removed because it is inside additional
>> ifdefs.
> Yes, it does not change functionality of the code.

I guess I even question if this include should actually be anywhere in
this file.

>>
>>> this file has #include of drmP.h, yet drmP.h is the only file I can
>>> find that includes drm_memory.h. Based on this I would think there is
>>> some additional cleanup that can go on here.
> How it can be cleaned up? Do you mean to move `define PAGE_AGP` to drmP.h?
>

It looks to me like this file at one time was meant to be included by
files other then drmP.h. Including drmP.h ensured __OS_HAS_AGP was
defined and a circular dependence was prevented by ifdefs surrounding
the bulk of drmP.h. As far as I can tell none of the includes in this
file are necessary anymore and a quick x86 compile seems to back me up
(please double check however). Once these are removed there is very
little functionality left and it might make more sense to just put in
into drmP.h. If in the future there is a need for this type of include
it can be started from scratch but for now I would say it should go
away.

Regards,
Mark
