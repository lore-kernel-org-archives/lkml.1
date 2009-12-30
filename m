Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbZL3XuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbZL3XuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 18:50:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbZL3XuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 18:50:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52278 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbZL3XuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 18:50:00 -0500
Message-ID: <4B3BE63B.70907@zytor.com>
Date: Wed, 30 Dec 2009 15:46:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: record relocation offset
References: <vxv6sfpjggfx6v68yv1eecrx.1262215615671@email.android.com> <1262216506.2749.254.camel@mulgrave.site>
In-Reply-To: <1262216506.2749.254.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2009 03:41 PM, James Bottomley wrote:
> On Wed, 2009-12-30 at 15:26 -0800, H. Peter Anvin wrote:
>> Modules are a completely separate thing - they are linked (not even
>> just relocated) at insertion time, so they need to be tracked
>> separately.
> 
> The reasons I gave was why _text relocation didn't work properly for
> systemtap.  The first paragraph was just giving a precis of history
> explaining to Arnaldo why he remembered there was a problem with _text
> based relocations.
> 
>> The statement that a _text-based relocation is insufficient is false.
>> The entire x86-32 monolithic kernel is relocated as a unit.  The
>> x86-64 kernel, too, is relocated as a unit, but using the page tables,
>> which means it always runs at the compile-time-selected virtual
>> address.
> 
> Confused now ... you just repeated what I said in the second paragraph,
> but made it sound like you are disagreeing?
> 

We might have a bit of a context mismatch.

The first I saw of this thread was a proposed patch that would give the
relocation offset of the monolithic kernel, both on 32 and 64 bits,
without any explanation of the usage model.  As such, from my point of
view this has always been about the monolithic kernel, until your post
mentioned modules (which the proposed patch would have done nothing about.)

The monolithic kernel offset is a single scalar constant; each module,
of course, is completely different.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

