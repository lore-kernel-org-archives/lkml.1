Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbZGDNDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbZGDNDt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 09:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZGDNDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 09:03:39 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60226 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbZGDNDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 09:03:38 -0400
Message-ID: <4A4F5211.10806@cs.helsinki.fi>
Date: Sat, 04 Jul 2009 15:58:57 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: bugzilla-daemon@bugzilla.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       bplant@iinet.net.au, Andrew Morton <akpm@linux-foundation.org>,
       mfasheh@suse.com, joel.becker@oracle.com
Subject: Re: [Bug 13631] BUG/panic - update_curr
References: <bug-13631-586@http.bugzilla.kernel.org/> <200907031523.n63FN96i031564@demeter.kernel.org>
In-Reply-To: <200907031523.n63FN96i031564@demeter.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brad,

bugzilla-daemon@bugzilla.kernel.org wrote:
> --- Comment #14 from Brad Plant <bplant@iinet.net.au>  2009-07-03 15:23:06 ---
> Created an attachment (id=22193)
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=22193)
> BUG kmalloc-16: Redzone overwritten
> 
> (In reply to comment #13)
>> Looking at the bug report, I'd be pretty surprised if this would be a
>> SLUB bug. It seems more likely that there's some memory corruption going
>> on under heavy load and SLAB just happens to have a different layout of
>> slab objects or something.
>>
>> Did you run the test with CONFIG_SLAB_DEBUG, btw?
> 
> I tried slub debugging first. I tried to make it crash for a while but of
> course it wouldn't do it when I wanted it to. I had given up on trying to crash
> slub and was just rebooting the node to change the kernel when I hit the
> jackpot.
> 
> Does this suggest ocfs2 is corrupting the memory?

Yup, that would be the prime suspect here. Lets cc ocfs2 developers and 
LKML. The corruption can be found here:

   http://bugzilla.kernel.org/attachment.cgi?id=22193

			Pekka
