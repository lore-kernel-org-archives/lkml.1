Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbYJ2VYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbYJ2VYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbYJ2VYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:24:37 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:18916 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbYJ2VYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:24:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jScycleztwsaMudRp6I+UrUsBFsYRkuI6fYu0T0KHeaoA6xYQeo8Gypk1iYAaxUaFj
         0qpbuZBQutDqfAqC44gxCybwV3cwBB/yDdB7MTNrDAwxyQWa4iHdGILlhpQzqsXhOCzo
         t8BJISuiYCc69zARfOEX83bxnnuERxzClMk7c=
Message-ID: <21d7e9970810291424g369035d4h562b54c676d49aef@mail.gmail.com>
Date: Thu, 30 Oct 2008 07:24:34 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: bob.montgomery@hp.com
Subject: Re: [PATCH] disable CPU side GART accesses
Cc: "Yinghai Lu" <yinghai@kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vojtech@suse.cz" <vojtech@suse.cz>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "chandru@in.ibm.com" <chandru@in.ibm.com>,
       "Joerg Roedel" <joerg.roedel@amd.com>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Pavel Machek" <pavel@ucw.cz>, "Andi Kleen" <ak@linux.intel.com>,
       "Dave Jones" <davej@redhat.com>
In-Reply-To: <1225313564.3428.14.camel@amd.troyhebe>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1224107317.2215.238.camel@amd.troyhebe>
	 <20081015234842.GA10999@elte.hu>
	 <1225147341.2215.401.camel@amd.troyhebe> <4906495B.1060506@kernel.org>
	 <1225313564.3428.14.camel@amd.troyhebe>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 6:52 AM, Bob Montgomery <bob.montgomery@hp.com> wrote:
> On Mon, 2008-10-27 at 23:06 +0000, Yinghai Lu wrote:
>> Bob Montgomery wrote:
>> > On Wed, 2008-10-15 at 23:48 +0000, Ingo Molnar wrote:
>> >> (Cc:-ed the GART folks.)
>> >
>> > Are there any objections to this patch?  The problem has been reproduced
>> > in 2.6.18 and 2.6.27, so existing changes in the gart code have not
>> > addressed it.
>>
>> better to have someone with amd system + 8g ram + agp adapter to verify it...
>>
>> YH
>
> Good idea.
>
> I don't think HP made a system with opteron and agp, so I haven't found
> a system here to test.  But I did see that there have been non-HP
> motherboards from several years ago that advertised opteron with agp.
> Anyone running that type of system?
>
> The other question is whether AGP graphics on linux for amd64 ever
> expected host translation to work, since setting DisGartCpu is turning
> off host translation.

We have an option in the AGP drivers called cant_use_aperture.

This stops the CPU from using the aperture for most DRI things. I
can't confirm this won't regress working systems
though. The whole AMD GART thing scares me, esp if some of the host
chipsets also have an AGP GART.

Dave.
