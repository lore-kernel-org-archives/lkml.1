Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbZKPVEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbZKPVEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbZKPVED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:04:03 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:38156 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbZKPVEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:04:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=FWB5oylHiVtGVaIrOnWVDh1VFxwxSCh8s32XjPHOmYGEeecO397hCLHoLB3RQtqnhG
         neAeS0wmBGzdy9TLJARrDQ6KTNPufg701cK8h/gdaPIvNbe4+4QiOlKsXrEXolbTo7ps
         YjKGVhzB9xQXHlCuN5ziBlSuZhZI9tkfui6dU=
Date: Mon, 16 Nov 2009 19:04:02 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 5/5] perf buildid-list: New plumbing command
Message-ID: <20091116210402.GA28963@ghostprotocols.net>
References: <1258396365-29217-1-git-send-email-acme@infradead.org> <1258396365-29217-2-git-send-email-acme@infradead.org> <1258396365-29217-3-git-send-email-acme@infradead.org> <1258396365-29217-4-git-send-email-acme@infradead.org> <1258396365-29217-5-git-send-email-acme@infradead.org> <20091116185850.GB5293@nowhere> <20091116194104.GC12042@ghostprotocols.net> <20091116205820.GA6984@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091116205820.GA6984@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 16, 2009 at 09:58:20PM +0100, Ingo Molnar escreveu:
> 
> * Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> 
> > Em Mon, Nov 16, 2009 at 07:58:52PM +0100, Frederic Weisbecker escreveu:
> > > On Mon, Nov 16, 2009 at 04:32:45PM -0200, Arnaldo Carvalho de Melo wrote:
> > > > With this we can list the buildids in a perf.data file so that we can
> > > > pipe them to other, distro specific tools that from the buildids can
> > > > figure out separate packages (foo-debuginfo) where we can find the
> > > > matching symtabs so that perf report can do its job.
> > > > E.g:
> > > > [acme@doppio linux-2.6-tip]$ perf buildid-list | head -2
> > > > 8e08b117e5458ad3f85da16d42d0fc5cd21c5869
> > > > 520c2387a587cc5acfcf881e27dba1caaeab4b1f
> > > > [acme@doppio linux-2.6-tip]$ perf buildid-list -v | head -2
> > > > 8e08b117e5458ad3f85da16d42d0fc5cd21c5869 /sbin/init
> > > > 520c2387a587cc5acfcf881e27dba1caaeab4b1f /lib64/ld-2.10.1.so
> > > 
> > > I would rather see the effect of this -v option as the default.
> > > It's very useful to see the dso resolved but hashes alone
> > > don't pay much.
> > 
> > I disagree, the main purpose of this command is equivalent to 'git
> > rev-list':
> > 
> > [acme@doppio linux-2.6-tip]$ git rev-list HEAD^^..
> > 089242a8c826aac1c827bb797475b9852fe0db49
> > 18e3a75dc47d8397bbf0936ec8e3ebdecada7ba1
> > [acme@doppio linux-2.6-tip]$ 
> > 
> > I.e. provide content keys that then will be used by distro specific
> > porcelain to get the matching -debuginfo packages with the symtabs.
> 
> Hm, i'd say that's a (small) bug in Git.
> 
> Porcelain can add flags just fine to get 'raw' behavior - so in general 
> we want to default the most human friendly parameters to the most 
> human-readable output format.

Well, no strong feelings here, make it the other way around and the most
usual case will just ignore those extra characters :-)

- Arnaldo
