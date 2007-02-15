Return-Path: <linux-kernel-owner+w=401wt.eu-S932302AbXBOBlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbXBOBlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 20:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932305AbXBOBlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 20:41:40 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58295 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302AbXBOBlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 20:41:39 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>,
       Ian Campbell <Ian.Campbell@XenSource.com>
Subject: Re: [patch 16/21] Xen-paravirt: Add code into head.S to handle being booted by Xen
References: <20070213221729.772002682@goop.org>
	<20070213221830.707197267@goop.org> <20070213235424.GA1908@muc.de>
	<45D35ABE.1050504@goop.org> <m1zm7gpkjh.fsf@ebiederm.dsl.xmission.com>
	<45D3740A.4080600@goop.org> <m17iukphxr.fsf@ebiederm.dsl.xmission.com>
	<45D3A5A4.7080804@goop.org>
Date: Wed, 14 Feb 2007 18:39:33 -0700
In-Reply-To: <45D3A5A4.7080804@goop.org> (Jeremy Fitzhardinge's message of
	"Wed, 14 Feb 2007 16:13:24 -0800")
Message-ID: <m1ire4nqqy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Eric W. Biederman wrote:
>> Ok.  If that is all this may be a difference that makes no difference.
>> binutils has a bad habit of looking at sections (which are fully
>> optional) instead of segments on ET_EXEC and ET_DYN objects.  Only
>> ET_REL objects (.o files) are required to have sections.
>>   
>
> The Xen domain loader will have to be changed to deal with that, which
> isn't too much of a problem.

Ok.  Please fix the Xen domain loader to not look at sections.  It
is a bug for any kind of executable loader to look at anything other
then segments.

> My main concern is the randomness of it, and whether it will fail in
> some more harmful way on other versions of binutils.

Reasonable and it's probably worth letting the binutils developer know.
I do agree that it is weird.   It might be that something in binutils
doesn't like us dropping some of the notes.

>> So I recommend for testing write a 100 line program that includes
>> elf.h and reads out the note segment.  If all is well we can split
>> this code out.
>>   
>
> The Xen readnotes utility is essentially that.  I'll hack it.

Sounds good.

Eric
