Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbYGNNaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbYGNNaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 09:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbYGNNai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 09:30:38 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:31682 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbYGNNah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 09:30:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nleu7aAx71QiThGNY+k3u7eHkBMUZd/Ws2zSoEoO74/PXmUppEa1Rq0t/cK/V8Egtj
         cicSEhmYzKmYCGLD0FsHgOlQChu2hSDI34oYdbfahLnnH8emCNT6tu7J1mg0m/cfXRwH
         +9XnJ1Se+bo5K2/9fDxowS+k43GHFMyg2uM0k=
Message-ID: <851fc09e0807140630w6edfa613oc176c6479808a6bd@mail.gmail.com>
Date: Mon, 14 Jul 2008 21:30:31 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm 1/2] kexec jump -v12: kexec jump
Cc: "Vivek Goyal" <vgoyal@redhat.com>, "Huang Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Pavel Machek" <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       "Kexec Mailing List" <kexec@lists.infradead.org>
In-Reply-To: <20080711122131.b6461ab1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1215401122.4660.4.camel@caritas-dev.intel.com>
	 <20080708145051.GA14745@redhat.com>
	 <20080711122131.b6461ab1.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2008 at 3:21 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 8 Jul 2008 10:50:51 -0400 Vivek Goyal <vgoyal@redhat.com> wrote:
>
>> On Mon, Jul 07, 2008 at 11:25:22AM +0800, Huang Ying wrote:
>> > This patch provides an enhancement to kexec/kdump. It implements
>> > the following features:
>> >
>> > - Backup/restore memory used by the original kernel before/after
>> >   kexec.
>> >
>> > - Save/restore CPU state before/after kexec.
>> >
>>
>> Hi Huang,
>>
>> In general this patch set looks good enough to live in -mm and
>> get some testing going.
>>
>> To me, adding capability to return back to original kernel looks
>> like a logical extension to kexec functionality.
>
> Exciting ;)  It's much less code than I expected.
>
> I don't think I understand the feature any more.  Once upon a time we
> thought that this might become a new and better (or at least
> better-code-sharing) way of doing suspend-to-disk.  How far are we from
> that?

At least there are still issues as follow:

- We need a mechanism to pass some information (such as backup pages
map) from hibernated kernel to hibernating kernel. Maybe in C calling
convention.
- To load hibernation image via /sbin/kexec, the segment number
constraint of sys_kexec_load needs to be extended (maybe via
multi-stage loading).
- Make kexec based hibernation compatible with ACPI S4.
- Extend makedumpfile utility for kexec based hibernation.

> What are the prospects of supporting other architectures?

I will work on x86_64 supporting.

> Who maintains kexec-tools, and are they OK with merging up the
> corresponding changes?

I will work with kexec-tools mailing list for corresponding kexec-tools patches.

Best Regards,
Huang Ying
