Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbXFOQeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbXFOQeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbXFOQeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:34:11 -0400
Received: from gw.goop.org ([64.81.55.164]:52091 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbXFOQeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:34:10 -0400
Message-ID: <4672BF82.9050101@goop.org>
Date: Fri, 15 Jun 2007 09:34:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-Devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 04/10] i386: clean up bzImage generation
References: <20070615004818.424726597@goop.org> <20070615005012.962196819@goop.org> <4672BC3E.6080308@zytor.com>
In-Reply-To: <4672BC3E.6080308@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>   
>> -setup_move_size: .word  0x8000		# size to move, when setup is not
>> +setup_move_size: .word  _setup_size	# size to move, when setup is not
>>  					# loaded at 0x90000. We will move setup
>>  					# to 0x90000 then just before jumping
>>  					# into the kernel. However, only the
>>     
>
> This is WRONG and will break 2.00 protocol bootloaders, if any still
> exist, and quite possibly some 2.01 protocol bootloaders.  There are
> definitiely bootloaders in the field that rely on this implicit value.
>   

Ah, I see.  I didn't see any documentation saying that this must be
0x8000.  Or does _setup_size just have to be <= 0x8000?

>> @@ -246,7 +246,6 @@ setup2:
>>  	jnz	1f
>>  	movw	$0xfffc, %sp	# Make sure we're not zero
>>  1:	movzwl	%sp, %esp	# Clear upper half of %esp
>> -	sti
>>     
>
> Motivation, please?
>   

We talked about this, and you said it was a mistake.  It needn't be in
this patch; it could be separate, or just dropped as far as I'm concerned.

    J
