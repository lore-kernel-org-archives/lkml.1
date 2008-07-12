Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYGLMbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYGLMbI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 08:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYGLMaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 08:30:55 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:3986 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbYGLMay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 08:30:54 -0400
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
From: Andi Kleen <andi@firstfloor.org>
References: <Pine.LNX.4.64.0807101702090.19775@engineering.redhat.com>
Date: Sat, 12 Jul 2008 14:30:04 +0200
In-Reply-To: <Pine.LNX.4.64.0807101702090.19775@engineering.redhat.com> (Mikulas Patocka's message of "Thu, 10 Jul 2008 17:56:08 -0400 (EDT)")
Message-ID: <87iqvb2skz.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Jul 2008 12:22:38.0393 (UTC) FILETIME=[F90FB290:01C8E419]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka <mpatocka@redhat.com> writes:

> I'm getting crashes with InitIO A100u2w controller on Sparc64 (I had
> to fix the endianity issues in the driver, but that's unrelated).

x86-64 (and powerpc) solved this a long time ago by only doing
opportunistic merging: as in don't announce to the block layer
that you can merge, but try to merge anyways. This way SG lists
are not necessarily filled completely, but it's still better
than overflowing them in some rare cases.

-Andi
