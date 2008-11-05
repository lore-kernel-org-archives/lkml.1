Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbYKESGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbYKESGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYKESGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:06:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51507 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbYKESGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:06:39 -0500
Message-ID: <4911E042.8040404@zytor.com>
Date: Wed, 05 Nov 2008 10:04:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Alexander van Heukelum <heukelum@fastmail.fm>,
       Andi Kleen <andi@firstfloor.org>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <20081104212933.GA11050@elte.hu> <4910C014.9070805@zytor.com> <20081104215245.GC17775@elte.hu> <20081105175318.GD7286@localhost>
In-Reply-To: <20081105175318.GD7286@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> Ingo, what the conclusion is? As I understand from the thread --
> 
> 1) Implement Peter's proposed cleanup/compress.
> 2) Test Alexander's patche.
> 
> Did I miss something?
> 

Nope, that's pretty much it.

However, there are good reason to believe that using this kind of
segment selector tricks is probably a bad idea in the long term,
especially since CPU vendors have strong incentives to reduce the size
of the segment descriptor cache now when none of the mainstream OSes
rely on more than a small handful of segments.

I was planning to look at doing the obvious stub shrink today.

	-hpa
