Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZICQwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZICQwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 12:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZICQwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 12:52:23 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:39260 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755987AbZICQwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 12:52:23 -0400
Subject: Re: [PATCH v2 2/5] kmemleak: add clear command support
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, mcgrof@gmail.com
In-Reply-To: <1251956140-5499-3-git-send-email-lrodriguez@atheros.com>
References: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
	 <1251956140-5499-3-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 03 Sep 2009 17:52:11 +0100
Message-Id: <1251996731.22485.25.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2009 16:52:12.0478 (UTC) FILETIME=[E23CB5E0:01CA2CB6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-03 at 01:35 -0400, Luis R. Rodriguez wrote:
> In an ideal world your kmemleak output will be small,
> when its not you can use the clear command to ingore previously
> annotated kmemleak objects. We do this by painting them black.

Making the objects "black" means that they are completely ignored by
kmemleak and they are assumed not to contain any valid references.
Therefore they won't be scanned and many of the newly allocated objects
would be false positives.

You may want to make them "gray" and only those which were reported as
unreferenced, something like below:

	if ((object->flags & OBJECT_REPORTED) && unreferenced_object(object))
		make_gray_object(object->pointer)

-- 
Catalin

