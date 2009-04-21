Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbZDUOCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbZDUOCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756457AbZDUOCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:02:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:47688 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbZDUOCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:02:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YWBYMiz5iwDP2NFg4gn6cnlE8DY216wsRX4vc5D4Qzxs0Ii8vj/9WavGZqk1EIPM3S
         GEahSypa1q8hxkiKj7NqwT63NZ6BtHT0gvLoFidhGJyWgiNsXrAuhrN71EJAbrKJmLHb
         m7Q61OP5Or8tYjhHzPV6cP2D1Ef4Dexi/QIaw=
Date: Tue, 21 Apr 2009 22:02:28 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH v2 0/4] Add support for compiling with
	-ffunction-sections -fdata-sections
Message-ID: <20090421140228.GC3303@hack>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238973278-31735-1-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 05, 2009 at 07:14:34PM -0400, Tim Abbott wrote:
>Hi Linus,
>
>Here is a new version of the -ffunction-sections -fdata-sections patch
>series based on your current master.  Please apply.
>
>When I sent a version of this patch series at the start of the merge
>window, Stephen Rothwell pointed out that the first patch conflicted
>with several changes in linux-next, and it should be resent near the
>end of the merge window once those changes were merged.  There are
>now no conflicting changes staged in linux-next[0], so now is probably
>the optimal time to merge this patch series.
>
>[0] There is one trivial merge conflict with next-20090403 because
>e5083a63b6a8546c5fe1e571fe529e3939787ec2 was merged into master since
>then, but this will presumably disappear when next catches up tomorrow.
>
>	-Tim Abbott
>
>--
>
>The purpose of this patch series is to make it possible to build the
>kernel with "gcc -ffunction-sections -fdata-sections".  There are two
>major applications for this functionality: decreasing vmlinux image
>size with --gc-sections, and Ksplice.

Hello, Tim!

Nice work! But, don't -ffunction-sections and -fdata-sections have
collisions with '-g' and 'gprof'? Just like what gcc(1) describes.

CONFIG_DEBUG_INFO relies on '-g', and IIRIC, another project of
linux kernel is trying to 'gprof' the kernel too.

So, CONFIG_FUNCTION_DATA_SECTIONS probably needs to depend on
!CONFIG_DEBUG_INFO etc.

Am I missing something?

Thanks.

-- 
Live like a child, think like the god.
 
