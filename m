Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZBYBGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZBYBGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 20:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZBYBFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 20:05:54 -0500
Received: from smtp-out.google.com ([216.239.45.13]:24175 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbZBYBFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 20:05:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=C+HIVvATfth0w1VnzMQEZF5QLnERRUMbwDISKOEQbudtUtWt9GrDPDLww34peyEXU
	1TmSdp5oPqKabSP5Jn5qw==
MIME-Version: 1.0
In-Reply-To: <1235456745.26788.237.camel@nimitz>
References: <20090224060558.GA14812@google.com>
	 <1235456745.26788.237.camel@nimitz>
Date: Tue, 24 Feb 2009 17:05:47 -0800
Message-ID: <4352991a0902241705o165106dbkd3d27829707e6ee6@mail.gmail.com>
Subject: Re: Another Performance Regression in write() syscall
From: Salman Qazi <sqazi@google.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Dave Hansen <haveblue@us.ibm.com>,
       nickpiggin@yahoo.com.au, Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 10:25 PM, Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> On Mon, 2009-02-23 at 22:05 -0800, Salman Qazi wrote:
>> Analysis of profile data has led us to believe that the commit
>> 3d733633a633065729c9e4e254b2e5442c00ef7e has caused a performance
>> regression.  This commit provides for tracking of writers so that read only
>> bind mounts function correctly.
>>
>> We can verify this regression by applying the following patch to partially
>> disable the above-mentioned commit and then running the fstime component
>> of Unixbench.  The settings used were 256 byte writes with MAX_BLOCK of 2000.
>
> I'm a bit surprised that write() is what is regressing.  Unless I
> screwed up, we do all the expensive accounting at open()/close() time.
> Is this a test that gets run in parallel on multiple cpus?
>
> Could you take a look at Nick's patches to speed this stuff up?
>
>        http://thread.gmane.org/gmane.linux.file-systems/28186
>

The pair of patches seems to fix our problem.  The benchmark results
for 2.6.29-rc6 + the above patches:

308200, 335850, 335900, 335150, 334700

Thanks for your help.

> We may need to dust those off, although I'm still a bit worried about
> the complexities of open-coding all the barriers.
>
> Could we also see some kind of profile?  What kind of machine are you
> seeing this on, btw?

It's an Opteron with with 4 cores.  Unfortunately, I don't have a
profile for the upstream kernel.

>
> -- Dave
>
>
