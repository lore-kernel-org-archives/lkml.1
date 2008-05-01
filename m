Return-Path: <linux-kernel-owner+w=401wt.eu-S1765728AbYEAUTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765728AbYEAUTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 16:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758334AbYEAUTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 16:19:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41605 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328AbYEAUTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 16:19:31 -0400
Message-ID: <481A2599.4080205@kernel.org>
Date: Thu, 01 May 2008 13:18:33 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
References: <20080429050605.GA27875@1wt.eu> <20080429072911.GA28059@cs181133002.pp.htv.fi> <20080429081423.GD30507@1wt.eu> <4816E4FD.5060605@aitel.hist.no> <20080429100934.GB1473@1wt.eu> <20080429111014.5a065b88@core> <20080429103335.GD1473@1wt.eu> <20080429113410.0971d071@core> <20080429221230.GA17360@1wt.eu> <20080429231554.69973c45@core> <20080429230511.GA18377@1wt.eu>
In-Reply-To: <20080429230511.GA18377@1wt.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Tue, Apr 29, 2008 at 11:15:54PM +0100, Alan Cox wrote:
>>> OK I could reproduce the case without ever involving either a shell or
>>> readline or anything. Using "cat" as the init program exhibited the
>>> anomaly, though it was not much easy to analyze. Then I switched to
>>> "init=od -An -tx1 -".
>> Did you put the console into utf-8 mode before the cat ?
> 
> I had not *explictly* disabled it, since as the doc suggests :
> 
>         vt.default_utf8=
>                         [VT]
>                         Format=<0|1>
>                         Set system-wide default UTF-8 mode for all tty's.
>                         Default is 1, i.e. UTF-8 mode is enabled for all
>                         newly opened terminals.
> 
> And I know that I can fix the behaviour by explicitly setting it to zero.
> Also, the fact that "od" shows me multi-byte characters on the input
> indicates to me that everything is set to UTF-8. So unless I'm missing
> something, my console is set by default to UTF-8 (I test this on 2.6.25).
> 

Yes, there is apparently a real bug here: this vt setting doesn't 
propagate to the tty layer iutf8 flag.

	-hpa
