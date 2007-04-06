Return-Path: <linux-kernel-owner+w=401wt.eu-S933004AbXDFVFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbXDFVFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933026AbXDFVFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:05:25 -0400
Received: from gw.goop.org ([64.81.55.164]:36958 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933004AbXDFVFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:05:23 -0400
Message-ID: <4616B5E7.9070508@goop.org>
Date: Fri, 06 Apr 2007 14:04:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
References: <20070406084250.GA179@tv-sign.ru>	<m18xd5amwq.fsf@ebiederm.dsl.xmission.com>	<20070406094413.GA673@tv-sign.ru>	<m1lkh58q16.fsf@ebiederm.dsl.xmission.com>	<20070406154750.GA541@tv-sign.ru>	<Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org>	<m1ejmx76fk.fsf@ebiederm.dsl.xmission.com>	<46169A34.3030808@zytor.com> <m1slbd5n7u.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1slbd5n7u.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> I'm guessing the issue is nash just calls wait and doesn't check the
> returned pid value, assuming it is the only child it forked returning.
> Which is valid except when you are running as pid == 1.
>   

Hm, that's always a bug; a process can always have children it doesn't
expect (think forking, and then the parent execs).

    J
