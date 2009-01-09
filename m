Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbZAITJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbZAITJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 14:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbZAITJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 14:09:33 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:42938 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbZAITJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 14:09:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JR8gYq/l1Hpb6bvihUv8Au+G7i1elDtej49CWQL0Pq8eOun1Jfou5pPGxhEM7/My7r
         A2cUXB/gfJJj+HwT1QI43nQgs+ST8G6M2KXOQlMgEg/h62duCVe2IuCDK+/s9ISyXHlm
         5a9+xFjRx1lMjm7r+AmCUZsfI58HJtBacuk68=
Message-ID: <84fc9c000901091109t2c2aef2fu596f8807b0962688@mail.gmail.com>
Date: Fri, 9 Jan 2009 20:09:28 +0100
From: "Richard Guenther" <richard.guenther@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Cc: "Matthew Wilcox" <matthew@wil.cx>, "Andi Kleen" <andi@firstfloor.org>,
       "Dirk Hohndel" <hohndel@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "jim owens" <jowens@hp.com>, "Chris Mason" <chris.mason@oracle.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Nick Piggin" <npiggin@suse.de>,
       "Peter Morreale" <pmorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, jh@suse.cz
In-Reply-To: <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <496648C7.5050700@zytor.com> <49675920.4050205@hp.com>
	 <20090109153508.GA4671@elte.hu> <49677CB1.3030701@zytor.com>
	 <20090109084620.3c711aad@infradead.org>
	 <20090109172011.GD26290@one.firstfloor.org>
	 <20090109172801.GC6936@parisc-linux.org>
	 <20090109174719.GG26290@one.firstfloor.org>
	 <20090109173914.GD6936@parisc-linux.org>
	 <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2009 at 6:54 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 9 Jan 2009, Matthew Wilcox wrote:
>>
>> That seems like valuable feedback to give to the GCC developers.
>
> Well, one thing we should remember is that the kernel really _is_ special.

(sorry for not threading properly here)

Linus writes:

"Thirdly, you're just replacing _one_ random gcc choice with _another_
random one.

What happens when you say -fno-inline-functions-called-once? Does it
disable inlining for those functions IN GENERAL, or just for the LARGE
ones? See?"

-fno-inline-functions-called-once disables the heuristic that always inlines
(static!) functions that are called once.  Other heuristics still
apply, like inlining
the static function if it is small.  Everything else would be totally
stupid - which
seems to be the "default mode" you think GCC developers are in.

Richard.
