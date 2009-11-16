Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbZKPS6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbZKPS6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 13:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZKPS6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 13:58:46 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:36395 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZKPS6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 13:58:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FY9gjHDcjsEbq7V6UUps3ne2TDQle1C5iS7tsqgSH5S9OD/CM1YKGCeCOiDR6YJZSv
         lk77/HLcn2O25+UmFpwRuSmmrKQHa5Jxe88+oJaHdMvDifQHWCcdwE1hAgK0wsj0LA6S
         TOV2hJE+MWec0z0LKg2BBt76r1ODvxGWor7j4=
Date: Mon, 16 Nov 2009 19:58:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 5/5] perf buildid-list: New plumbing command
Message-ID: <20091116185850.GB5293@nowhere>
References: <1258396365-29217-1-git-send-email-acme@infradead.org> <1258396365-29217-2-git-send-email-acme@infradead.org> <1258396365-29217-3-git-send-email-acme@infradead.org> <1258396365-29217-4-git-send-email-acme@infradead.org> <1258396365-29217-5-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258396365-29217-5-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 04:32:45PM -0200, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> With this we can list the buildids in a perf.data file so that we can
> pipe them to other, distro specific tools that from the buildids can
> figure out separate packages (foo-debuginfo) where we can find the
> matching symtabs so that perf report can do its job.
> 
> E.g:
> 
> [acme@doppio linux-2.6-tip]$ perf buildid-list | head -5
> 8e08b117e5458ad3f85da16d42d0fc5cd21c5869
> 520c2387a587cc5acfcf881e27dba1caaeab4b1f
> ec8dd400904ddfcac8b1c343263a790f977159dc
> 7caedbca5a6d8ab39a7fe44bd28c07d3e14a3f3f
> 379bb828fd08859dbea73279f04abefabc95a6a3
> [acme@doppio linux-2.6-tip]$ perf buildid-list -v | head -5
> 8e08b117e5458ad3f85da16d42d0fc5cd21c5869 /sbin/init
> 520c2387a587cc5acfcf881e27dba1caaeab4b1f /lib64/ld-2.10.1.so
> ec8dd400904ddfcac8b1c343263a790f977159dc /lib64/libc-2.10.1.so
> 7caedbca5a6d8ab39a7fe44bd28c07d3e14a3f3f /sbin/udevd
> 379bb828fd08859dbea73279f04abefabc95a6a3 /lib64/libdl-2.10.1.so


I would rather see the effect of this -v option as the default.
It's very useful to see the dso resolved but hashes alone
don't pay much.

