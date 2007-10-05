Return-Path: <linux-kernel-owner+w=401wt.eu-S1759775AbXJEKnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759775AbXJEKnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 06:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbXJEKnC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 06:43:02 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:65196 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbXJEKnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 06:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=iWavJtqX7Ocq9C50RBvbXTn/w2QkHLZkxDQ7E9dU+uxc9XmYZA9pnbiFFWCmNnY4xPXQazb9wGjTrFFEXquvdzPfzH+dSEEcUuglDky3kG1WiR8vkP/Kl6+tV8+76/FxhgcYm1iH7RyIswVA1nYLP6YjrGASALixDplpdSwr1bE=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC] [PATCH] Add more info to /proc/$pid/smaps
Date: Fri, 5 Oct 2007 12:42:41 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710051242.41867.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was trying to write a small application similar to pmap, but more powerful.
During the writing I noticed that there are two things I can't get by parsing /proc/$pid/smaps:

1) amount of anonymous memory in a mapping:

It is easy to get it for shared and anonymous mappings (0 for the former, and whole mapping for the latter)
But it is impossible to get it for private writable file mappings.

It seems that the dirty (Private_Dirty+Shared_Dirty) pages amount should indicate number of anonymous pages in the mapping
but this is not the case.

If a dirty page gets swapped, and then brought back due to read access, it will be marked clean, although it is an anonymous page.

2) amount of swapped memory in a mapping:

Again it seems that I can do (Mapping size - RSS) to get amount of memory swapped, but this isn't true too, since
some memory can be untouched , thus be non-present, and non-swapped.


The patch below adds two fields to /proc/$pid/smaps, that give this information.

Probably even more info will be interesting.
How about adding amount of locked memory, and most importantly map count?
This way I can estimate how 'shared' a process memory really is.

Suggestions are welcome.

Best regards,
	Maxim Levitsky
