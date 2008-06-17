Return-Path: <linux-kernel-owner+w=401wt.eu-S1760004AbYFQWUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004AbYFQWUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758002AbYFQWUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:20:07 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:47015 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973AbYFQWUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:20:06 -0400
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: copy_from_user again()
From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 18 Jun 2008 00:19:03 +0200
Message-ID: <87hcbrwvqg.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Jun 2008 22:11:49.0022 (UTC) FILETIME=[2359DBE0:01C8D0C7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Just in case you read that:

I thought a little more about your patch. One problem I see (and that is why
I aborted my version of it too) is that it becomes very inaccurate now in reporting.

So for example when you have a source like

offset

0
4
8
<---> unmapped boundary

and it starts copying from 0-8 and faults then with your patch it will
return full size even though it could have copied 8 bytes (return size
- 8) That is what I meant by breaking it.  Arguably it's just a
different breakage.

IIRC mount was quite sensitive to that, as in it passed some data before
the a fault boundary and relies on that data getting through. It might
be lucky with the alignment or it might now.

So with your change the exception handler would also need to be fixed
to copy the non faulted part to the target.

-Andi

