Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbZKUEnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbZKUEnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 23:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZKUEnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 23:43:37 -0500
Received: from lo.gmane.org ([80.91.229.12]:47338 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbZKUEn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 23:43:28 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ben Pfaff <blp@cs.stanford.edu>
Subject: Re: Easier way to generate stuff like asm-offsets.
Date: Fri, 20 Nov 2009 20:43:16 -0800
Message-ID: <87aaygfpy3.fsf@blp.benpfaff.org>
References: <3f43f78b0911201656o6d222e6fkf5ef8533c8ee6e16@mail.gmail.com>
Reply-To: blp@cs.stanford.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: c-67-180-165-166.hsd1.ca.comcast.net
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Cancel-Lock: sha1:/VVlqHEUrCkAKHvoyp/2/wHKGCs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kaz Kylheku <kkylheku@gmail.com> writes:

> Then we can use the ``nm'' tool (the toolchain should have binutils in it):
>
> $ /path/to/toolchain/bin/arch-prefix-nm -t d -P foo.c   # decimal
> output, posix format
> offsetof_foo_member C 00000044 00000044

If those numbers are in decimal...

> There we go, 44 bytes.  Simple.  This is almost an #include file;
> we just have to do some simple filtering, such as:
>
> $ /path/to/toolchain/bin/arch-prefix-nm -t d -P test.o | awk '{ print
> "#define", $1, $4 }'
> #define offsetof_foo_member 00000044

...then the #define is wrong because it's interpreted as octal
there.

Cool trick!
-- 
Ben Pfaff 
http://benpfaff.org

