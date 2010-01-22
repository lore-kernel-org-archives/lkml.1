Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122Ab0AVTdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0AVTdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 14:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989Ab0AVTd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 14:33:28 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:43724 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab0AVTdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 14:33:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=SKDxrFs6RaQaOgfmM389DFWvtYDR0XagEKv0N5oIIEE4NvG/GDuOgPvvgjwMcawAHI
         2uYo1pnpD2heGxefMoxTjfTuId6UK0TjUuh2otZpPfkEEmuTZnAaWoE6IZThxpX0oEgB
         Mk/nqEyz/keMhqWFk7bvZvRSKzZBW/FMJQJYQ=
MIME-Version: 1.0
In-Reply-To: <20100122163700.GD6412@osiris.boeblingen.de.ibm.com>
References: <1264167826-20913-1-git-send-email-vapier@gentoo.org> 
	<1264170977.31321.382.camel@gandalf.stny.rr.com> <20100122163700.GD6412@osiris.boeblingen.de.ibm.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 22 Jan 2010 14:32:56 -0500
Message-ID: <8bd0f97a1001221132h331224ccif94f169750c1714b@mail.gmail.com>
Subject: Re: [PATCH] ftrace: unify arch_syscall_addr() implementations
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 11:37, Heiko Carstens wrote:
> On Fri, Jan 22, 2010 at 09:36:17AM -0500, Steven Rostedt wrote:
>> On Fri, 2010-01-22 at 08:43 -0500, Mike Frysinger wrote:
>> > Every arch_syscall_addr() implementation thus far is the same, so unify
>> > them as a default weak in common code so more arches don't have to waste
>> > time copying & pasting this simple function.  The Blackfin version is
>> > going to be exactly the same.
>> >
>> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> > ---
>> > note: only thing that needs double checking is s390 and sparc where they
>> > declared the sys_call_table as an array of ints.  considering this table
>> > is supposed to be an array of function pointers, this seems like more of
>> > a typo to me ...
>>
>> I would not be too sure. s390 is very strange, and I would definitely
>> want to get an Ack from the arch maintainers first.
>
> It's not a typo. The syscall table on s390 contains always 32 bit pointers
> since we know that the address of the function to be called is (way) below
> 4GB. So this saves us a few bytes.
> In addition this makes syscall patching done by some security modules a
> bit more difficult, since they would need to store a 64 bit pointer.
> That's because we make sure that module addresses are always above 4GB.

i'll update the s390 code to add an explanatory comment then and post
a new version
-mike
