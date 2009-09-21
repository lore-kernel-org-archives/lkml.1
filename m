Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbZIULHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbZIULHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 07:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbZIULHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 07:07:17 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54947 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZIULHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 07:07:16 -0400
Subject: Re: shmem_fill_super(): WARNING: kmemcheck: Caught 32-bit read
 from uninitialized memory
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0909211126080.32504@sister.anvils>
References: <20090915080953.GA24958@elte.hu>
	 <20090920072210.GA23787@elte.hu>
	 <19f34abd0909201035t3157948amee532a3a5e96dbab@mail.gmail.com>
	 <alpine.DEB.2.00.0909202046460.7394@melkki.cs.helsinki.fi>
	 <Pine.LNX.4.64.0909211126080.32504@sister.anvils>
Date: Mon, 21 Sep 2009 14:07:19 +0300
Message-Id: <1253531239.5216.27.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On Mon, 2009-09-21 at 11:49 +0100, Hugh Dickins wrote:
> I got a bit anxious when I saw that the mode arg to shmem_get_inode()
> is declared as an int: was afraid that compiler was then passing a bad
> upper half down, which in fact would cause no trouble, but how could it
> be sure of that?  However, it looks okay: after doing the 32-bit load,
> it goes on to do a movzwl %ax,%eax - seems an odd way to proceed to me,
> but I bet it knows a lot more about efficiency of memory loads than I do.

Yeah, that's a common cause of kmemcheck false positives. I guess GCC
wants to avoid a partial register stall in the memory load and expects
CPU register renaming to work for "movzwl %ax, %eax" or something.

			Pekka

