Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbYCaR4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbYCaR4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 13:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYCaR4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 13:56:15 -0400
Received: from relay2.sgi.com ([192.48.171.30]:35688 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753235AbYCaR4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 13:56:14 -0400
Date: Mon, 31 Mar 2008 12:56:11 -0500
From: Paul Jackson <pj@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: bert.wesarg@googlemail.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: modify show_shared_cpu_map in intel_cacheinfo
Message-Id: <20080331125611.9ad42e8f.pj@sgi.com>
In-Reply-To: <47F112BD.4050801@sgi.com>
References: <20080327231654.284673000@polaris-admin.engr.sgi.com>
	<20080327231654.599276000@polaris-admin.engr.sgi.com>
	<36ca99e90803280201i708ce9b7y293a2c68e733f088@mail.gmail.com>
	<47ED0343.1070708@sgi.com>
	<36ca99e90803280754p1fbedbccp366366f0240fe5cc@mail.gmail.com>
	<47ED36B9.6000508@sgi.com>
	<36ca99e90803290159v33ab43cbu5acd4bc2b0cd0262@mail.gmail.com>
	<47F112BD.4050801@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  I did an informal survey and you are right, the majority of references do use
>>  cpumask_scnprintf instead of cpulist_scnprintf.  Maybe the later function was
>>  added later?

My recollection is that I added cpulist_scnprintf later, yes.
Looking at my email archives, I see the mask versions mentioned
starting Feb 2004, and the list versions starting Aug 2004.

My rule of thumb has been to use the mask style (00000000,0000ffff)
for lower level interfaces, and the list style (0-15) for higher level
interfaces.

For long lists, the list style is easier for humans to read, but for
one word masks, the mask style can be easier to read for -some-
purposes and are more commonly used.

If you throw enough user level software at them, the lists are no more
or less difficult to form or parse.  Hand coded C parsers are probably
easier to write for the mask style, and might be closer to what low
level (closer to the hardware) programmers expect.

Certainly, a particular interface should not change once it goes public.

Once picked for a new interface, I don't recall ever seeing any significant
controversy over which one was picked.  So another of my rules of thumb
might apply here -- coders choice.  He who writes the code gets to make
the open choices.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
