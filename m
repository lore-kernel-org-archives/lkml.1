Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbXFOQVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbXFOQVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbXFOQU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:20:58 -0400
Received: from terminus.zytor.com ([192.83.249.54]:40460 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370AbXFOQU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:20:57 -0400
Message-ID: <4672BC3E.6080308@zytor.com>
Date: Fri, 15 Jun 2007 09:20:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-Devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 04/10] i386: clean up bzImage generation
References: <20070615004818.424726597@goop.org> <20070615005012.962196819@goop.org>
In-Reply-To: <20070615005012.962196819@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> -setup_move_size: .word  0x8000		# size to move, when setup is not
> +setup_move_size: .word  _setup_size	# size to move, when setup is not
>  					# loaded at 0x90000. We will move setup
>  					# to 0x90000 then just before jumping
>  					# into the kernel. However, only the

This is WRONG and will break 2.00 protocol bootloaders, if any still
exist, and quite possibly some 2.01 protocol bootloaders.  There are
definitiely bootloaders in the field that rely on this implicit value.

> @@ -246,7 +246,6 @@ setup2:
>  	jnz	1f
>  	movw	$0xfffc, %sp	# Make sure we're not zero
>  1:	movzwl	%sp, %esp	# Clear upper half of %esp
> -	sti

Motivation, please?

	-hpa

