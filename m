Return-Path: <linux-kernel-owner+w=401wt.eu-S932076AbZJ0G5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbZJ0G5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 02:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756396AbZJ0G5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 02:57:31 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:51397 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287AbZJ0G5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 02:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=FiH9kXdRx7FdRIEOdGU9ON+D9OTmjXGFcwEr8KoamusFrz8Yy4tVhmSQmBn3cf6qZh
         mHeM2RAFF3RR7razqcKMcsa2DxJwi7fQmq1QoVa/5BP1L0Rbf9CJOI6qEDHcWCkQrlpX
         A63tBxGbTH+Zv9aDFAkd/9ADaYCUgAFEvuc2Q=
Date: Tue, 27 Oct 2009 15:56:59 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       vedran.furac@gmail.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: Memory overcommit
Message-Id: <20091027155659.bed644ce.minchan.kim@barrios-desktop>
In-Reply-To: <20091027154429.E2A4.A69D9226@jp.fujitsu.com>
References: <2f11576a0910262310g7aea23c0n9bfc84c900879d45@mail.gmail.com>
	<20091027153429.b36866c4.minchan.kim@barrios-desktop>
	<20091027154429.E2A4.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 15:46:36 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > > > %check_badness.pl | sort -n | tail
> > > > --
> > > > 89924   3938    mixer_applet2
> > > > 90210   3942    tomboy
> > > > 94753   3936    clock-applet
> > > > 101994  3919    pulseaudio
> > > > 113525  4028    gnome-terminal
> > > > 127340  1       init
> > > > 128177  3871    nautilus
> > > > 151003  11515   bash
> > > > 256944  11653   mmap
> > > > 425561  3829    gnome-session
> > > > --
> > > > Sigh, gnome-session has twice value of mmap(1G).
> > > > Of course, gnome-session only uses 6M bytes of anon.
> > > > I wonder this is because gnome-session has many children..but need to
> > > > dig more. Does anyone has idea ?
> > > > (CCed kosaki)
> > > 
> > > Following output address the issue.
> > > The fact is, modern desktop application linked pretty many library. it
> > > makes bloat VSS size and increase
> > > OOM score.
> > > 
> > > Ideally, We shouldn't account evictable file-backed mappings for oom_score.
> > > 
> > Hmm. 
> > I wonder why we consider VM size for OOM kiling. 
> > How about RSS size?
> 
> Because, swap out-ed bad body (e.g. fork bomb process) still should
> be killed by oom.
> RSS + swap-entries is acceptable to me.

It's reasonable to me.
As I mentioned by reply of kame, in Vedran case, he didn't use swap. 
I think only considering vm is the problem.

-- 
Kind regards,
Minchan Kim
