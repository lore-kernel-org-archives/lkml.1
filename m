Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbYGMPgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbYGMPgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 11:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbYGMPgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 11:36:22 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:50493 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbYGMPgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 11:36:21 -0400
To: John Keller <jpk@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       takayoshi.kochi@gmail.com
Subject: Re: [PATCH] x86: Allow MMCONFIG above 4GB on x86_64
From: Andi Kleen <andi@firstfloor.org>
References: <20080709204127.1458.5727.77728@attica.americas.sgi.com>
Date: Sun, 13 Jul 2008 17:36:18 +0200
In-Reply-To: <20080709204127.1458.5727.77728@attica.americas.sgi.com> (John Keller's message of "Wed,  9 Jul 2008 15:41:27 -0500 (CDT)")
Message-ID: <87r69xzthp.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Jul 2008 15:28:52.0259 (UTC) FILETIME=[279E1730:01C8E4FD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Keller <jpk@sgi.com> writes:
>
> A similar patch was submitted over a year ago, but apparently was not
> merged in.

There's no reason at all to make this 64bit only. A PAE 32bit kernel
can also access data above 4GB. So an ifdef is the wrong way.

The reason the check is there is that there are lots of 
x86 BIOS that report wrong mmconfig and this way there's another
sanity check.

You'll need either to find a way to preserve this check
on kernels not running on your system or show that the 
sanity check is not needed anymore. The later would 
be likely tricky.

-Andi

