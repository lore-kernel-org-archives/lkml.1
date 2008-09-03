Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYICE46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYICE46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 00:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYICE4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 00:56:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:19317 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYICE4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 00:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jMtVJJjlR5P9O8PkPf3b2i/FCtNvIR4WPv0bUZTfOTH8KkLNPjrvcVNq63du2P7s4y
         KiSyqRrJhEa1dsESo4o/1Gh2+ZYmTnZ03qMcdeGzNrDxWRRaRodVGhbo8z5yzj3ID9Yo
         lKlBsXFvSWfmUKuvSn769FyxQQ+ImCX4dfDm8=
Message-ID: <86802c440809022156t598ee53fvdd2ae60626737b23@mail.gmail.com>
Date: Tue, 2 Sep 2008 21:56:47 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bob Tracy" <rct@gherkin.frus.com>
Subject: Re: [BUG] /proc/mtrr I/O error
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080903035821.GA2293@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080829213824.GA2281@gherkin.frus.com>
	 <20080902154620.314ad5c2.akpm@linux-foundation.org>
	 <86802c440809021608s54725294t5629255bb1f0c9@mail.gmail.com>
	 <20080903035821.GA2293@gherkin.frus.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2008 at 8:58 PM, Bob Tracy <rct@gherkin.frus.com> wrote:
> On Tue, Sep 02, 2008 at 04:08:00PM -0700, Yinghai Lu wrote:
>> On Tue, Sep 2, 2008 at 3:46 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> > On Fri, 29 Aug 2008 16:38:24 -0500
>> > Bob Tracy <rct@gherkin.frus.com> wrote:
>> >
>> >> With 2.6.27-rc4 and possibly earlier kernels, I see the following:
>> >>
>> >> $ cat /proc/mtrr
>> >> cat: /proc/mtrr: Input/output error
>> >>
>> >> Processor is an AMD K6-III/450.
>> >>
>> >
>> > static int mtrr_open(struct inode *inode, struct file *file)
>> > {
>> >        if (!mtrr_if)
>> >                return -EIO;
>> >
>> >
>> >
>> > Beats me.  Perhaps something broke in mtrr_bp_init().
>> >
>> > It would be useful to know if 2.6.26 worked OK.
>> >
>>
>> two patches needed..
>>
>> http://lkml.org/lkml/2008/9/1/307
>>    [PATCH 4/6] x86: delay early cpu initialization until cpuid is done
>> http://lkml.org/lkml/2008/9/1/308
>>   [PATCH 5/6] x86: move mtrr cpu cap setting early in early_init_xxxx
>
> Krzysztof Helt's quick-and-dirty patch posted a few days ago did the
> trick, but from the descriptions of the above patches, they address the
> problem properly.  Here's what "cat /proc/mtrr" shows with Helt's patch
> and the "nv" driver active for my GeForce2 MX 400 card:
>
> $ cat /proc/mtrr
> reg00: base=0xd0000000 (3328MB), size=  64MB: write-combining, count=1
>
> MTRR sanitization seems to be working properly: the same command shows
> nothing when X isn't running.

did you apply them both
  [PATCH 4/6] x86: delay early cpu initialization until cpuid is done
  [PATCH 5/6] x86: move mtrr cpu cap setting early in early_init_xxxx

YH
