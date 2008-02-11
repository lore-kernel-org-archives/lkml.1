Return-Path: <linux-kernel-owner+w=401wt.eu-S1757793AbYBKRyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbYBKRyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYBKRxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:53:55 -0500
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:50475 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751040AbYBKRxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:53:54 -0500
Date: Mon, 11 Feb 2008 18:53:52 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Parag Warudkar" <parag.warudkar@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH] dmi: Prevent linked list corruption (resent)
Message-ID: <20080211185352.3e22ac6b@hyperion.delvare>
In-Reply-To: <82e4877d0802110935v11e4bdf8l783a9834ca0a950d@mail.gmail.com>
References: <20080211182235.14a5a641@hyperion.delvare>
	<20080211182440.071c47d9@hyperion.delvare>
	<82e4877d0802110935v11e4bdf8l783a9834ca0a950d@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Parag,

On Mon, 11 Feb 2008 12:35:39 -0500, Parag Warudkar wrote:
> On Feb 11, 2008 12:24 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > [Once more without forgetting the last "quilt refresh", sorry.]
> >
> > Adding the same item to a given linked list more than once is guaranteed
> > to break and corrupt the list. This is however what we do in dmi_scan
> > since commit 79da4721117fcf188b4b007b775738a530f574da.
> >
> > Given that there is absolutely no interest in saving empty OEM
> > strings anyway, I propose the simple and efficient fix below: we
> > discard the empty OEM strings altogether.
> >
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Cc: Parag Warudkar <parag.warudkar@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> 
> I suppose the list would be corrupted only if there are deletions from
> the list? (Which there aren't.)

As I understand the way doubly linked lists are implemented in Linux, I
think that the corruption exists even if you are only adding items to
the list. Each struct dmi_device contains a list_head which points to
the previous and next items in the list. If you add a struct dmi_device
that was already in the list, you are overwriting this list_head with
new pointers and you lose the pointers that were originally there. This
means that you have created a "shortcut" from one list item to another
item that is further in the list, and the items in-between them are no
longer reachable.

> Anyway not adding the empty strings is way better and I don't see now
> how they could've been useful.
> (I added them out of the doubt of breaking something.)
> 
> Acked-By: Parag Warudkar <parag.warudkar@gmail.com>

Thanks,
-- 
Jean Delvare
