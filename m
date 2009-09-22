Return-Path: <linux-kernel-owner+w=401wt.eu-S1751402AbZIVAvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbZIVAvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 20:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbZIVAvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 20:51:40 -0400
Received: from science.horizon.com ([71.41.210.146]:25671 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751110AbZIVAvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 20:51:40 -0400
Date: 21 Sep 2009 20:51:34 -0400
Message-ID: <20090922005134.20722.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: Joel.Becker@oracle.com
Subject: Re: [GIT PULL] ocfs2 changes for 2.6.32
Cc: linux@horizon.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Perhaps ->copyfile takes the following flags:
>
> #define ALLOW_COW_SHARED	0x0001
> #define REQUIRE_COW_SHARED	0x0002
> #define REQUIRE_BASIC_ATTRS	0x0004
> #define REQUIRE_FULL_ATTRS	0x0008
> #define REQUIRE_ATOMIC		0x0010
> #define SNAPSHOT		(REQUIRE_COW_SHARED |
>				 REQUIRE_BASIC_ATTRS |
>				 REQUIRE_ATOMIC)
> #define SNAPSHOT_PRESERVE	(SNAPSHOT | REQUIRE_FULL_ATTRS)

Um, could I strongly suggest that flags == 0 be the "succeed if at all
possible case", and various options limit it.

In particular, invert ALLOW_COW_SHARED to REQUIRE_ALLOCATE.

Another possibly useful flag would be REQUIRE_OPTIMIZED.
I.e. if it's not appreciably faster than a read/write loop, perhaps
the application would prefer to do it itself.

We also have to define the error code to return in case of a flag
violation.  ENOTSUP?
