Return-Path: <linux-kernel-owner+w=401wt.eu-S1751488AbZKUHO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbZKUHO7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 02:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZKUHO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 02:14:58 -0500
Received: from ellpspace.math.ualberta.ca ([129.128.207.67]:41599 "EHLO
	ellpspace.math.ualberta.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114AbZKUHO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 02:14:58 -0500
X-Greylist: delayed 3897 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Nov 2009 02:14:58 EST
Date: Fri, 20 Nov 2009 23:10:06 -0700
From: Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
To: Kaz Kylheku <kkylheku@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Easier way to generate stuff like asm-offsets.
Message-ID: <20091121061006.GA13067@ellpspace.math.ualberta.ca>
References: <3f43f78b0911201656o6d222e6fkf5ef8533c8ee6e16@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f43f78b0911201656o6d222e6fkf5ef8533c8ee6e16@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 04:56:14PM -0800, Kaz Kylheku wrote:
> 
> Here is the simple trick:
....
> 
> Now we compile test.c:
> 
> $ /path/to/toolchain/bin/arch-prefix-gcc test.c -c
> 
> Then we can use the ``nm'' tool (the toolchain should have binutils in it):
> 
> $ /path/to/toolchain/bin/arch-prefix-nm -t d -P foo.c   # decimal
> output, posix format
> offsetof_foo_member C 00000044 00000044
> 
> There we go, 44 bytes.  Simple.  This is almost an #include file;
> we just have to do some simple filtering, such as:
> 
> $ /path/to/toolchain/bin/arch-prefix-nm -t d -P test.o | awk '{ print "#define", $1, $4 }'
> #define offsetof_foo_member 00000044

If that is a "decimal output" then resulting define has a wrong format.
You do not want octal.  Fix that with
   ... | awk '{print "#define", $1, 0 + $4}'
to force a conversion of a string to a number.

   Michal
