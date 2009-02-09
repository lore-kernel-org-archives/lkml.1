Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZBIPCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZBIPCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 10:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZBIPCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 10:02:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50976 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbZBIPCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:02:30 -0500
Date: Mon, 9 Feb 2009 10:02:28 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: Re: [PATCH] ftrace, powerpc64: fix math to calculate offset in TOC
In-Reply-To: <20090209094014.GE7930@elte.hu>
Message-ID: <alpine.DEB.1.10.0902091000400.14528@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0902080118480.30802@gandalf.stny.rr.com> <20090209094014.GE7930@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 9 Feb 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > Paul,
> > 
> > I found the bug that was causing large modules to fail in setting
> > up dynamic ftrace. It wound up being a simple math error. To calculate
> > the offset in the TOC, I had used an OR, but the bottom half was
> > a signed extended short, and it should have been an addition.
> > The fix is in my tree below, as well as posted here.
> 
> Looks like a .29 candidate?

Ingo,

I think Ben pulled them into their tree. The changes are specific to ppc, 
and will probably get better user testing there. Unless you feel that we 
have a bit of ppc testers using tip.

-- Steve

