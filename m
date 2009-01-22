Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbZAVN3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbZAVN3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 08:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZAVN3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 08:29:22 -0500
Received: from relay2.sgi.com ([192.48.179.30]:50697 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751886AbZAVN3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 08:29:21 -0500
Date: Thu, 22 Jan 2009 07:31:07 -0600
From: Cliff Wickman <cpw@sgi.com>
To: jidong xiao <jidong.xiao@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to generate a Kerntypes file?
Message-ID: <20090122133107.GA27592@sgi.com>
References: <4104961b0901220259u51677cbdkda2ed84dc2892543@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4104961b0901220259u51677cbdkda2ed84dc2892543@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Thu, Jan 22, 2009 at 06:59:34PM +0800, jidong xiao wrote:
> Hi,All,
> 
> Sometimes when I install a kernel I saw there is a Kerntypes file
> installed under /boot directory, but sometimes no, I remember when I
> install a sles9 kernel, there must be a Kerntypes file installed, but
> most of other kernels doesn't include such a Kerntypes file. This file
> is very useful for me to do some analysis, so I hope I can generate it
> every time I build a kernel. Do I need a patch for this or there are
> already some patches I can take use of?Thanks.

You had a init/kerntypes.c in sles9 and sles10. It included a lot
of basic kernel types.  It was compiled with -g to make the kerntypes.
I presume that you used the LKCD project's lcrash with the kerntypes.

If you download lkcd (lkcd.svn.sourceforge.net) you also build a
tool called dwarfextract.  It is able to pull all the structure
definitions out of a -g (CONFIG_DEBUG_INFO) kernel and any selected
modules.  That is useful with the lcrash command.

If you want to analyze your live system or a dump with the crash command
(people.redhat.com/~anderson/) you don't need the kerntypes, as you use
the -g kernel itself.  Although you may make kerntypes with dwarfextract
and use them with crash also.

-Cliff

> Regards
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
