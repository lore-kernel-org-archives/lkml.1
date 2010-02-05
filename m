Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab0BEJyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 04:54:17 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:61815 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab0BEJyQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 04:54:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VdC2W4E7BkJIu9OH9mSp7xNmwPlYyPgoBztaDnDb4uKif1ASwePSwdAs3o07ZDFGX8
         v6dz9t33GRzJIrIZ3WmFeQGkDjRCHiCjsLGoyMDw0JMQ50d9M6pUok77Pvlar8ER8zvj
         s4lcRtc0aFrGC1UqOM4Ie76ywNeuAkN4UL2vo=
MIME-Version: 1.0
In-Reply-To: <20100203174947.GA13943@tango.0pointer.de>
References: <20100202120457.GA19605@omega> <20100203153101.GC4177@hack>
	 <20100203174947.GA13943@tango.0pointer.de>
Date: Fri, 5 Feb 2010 17:54:14 +0800
Message-ID: <2375c9f91002050154m1d179ea7v91c8253b41fc63eb@mail.gmail.com>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers for 
	child processes
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 4, 2010 at 1:49 AM, Lennart Poettering <mzxreary@0pointer.de> wrote:
> On Wed, 03.02.10 23:31, Américo Wang (xiyou.wangcong@gmail.com) wrote:
>
>> On Tue, Feb 02, 2010 at 01:04:57PM +0100, Lennart Poettering wrote:
>> >
>> >This patch adds a simple flag for each process that marks it as an
>> >"anchor" process for all its children and grandchildren. If a child of
>> >such an anchor dies all its children will not be reparented to init, but
>> >instead to this anchor, escaping this anchor process is not possible. A
>> >task with this flag set hence acts is little "sub-init".
>>
>> This will break the applictions which using 'getppid() == 1' to check
>> if its real parent is dead or not...
>
> Usage of the PR_SETANCHOR flag is optional for a process. It won't
> break anything unless enabled. So I don't really see a problem here.
>
> Of course, when this flag is used the behaviour is different from what
> traditional Unix says what happens with the children of a process when
> it dies. But uh, that's the whole point and that's why this flag is
> enabled optionally only.


As for the example you mentioned, gnome-session, with your patch
applied, it will use this to set itself as "anchor", all the programs that
are started within it will be children of it. If one of these programs uses
"getppid() == 1" trick, it will break it.

>
> Also, on a side note: code that checks if its parent process died most
> likely should rewritten to use PR_DEATHSIG or something like that
> anyway, so that it is notified about the parent dying instead of
> polling for it manually.
>

I agree, but this is not a reason for you to break the compatiblity.
