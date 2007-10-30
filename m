Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbXJ3UFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbXJ3UFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbXJ3UFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:05:45 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50263 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758593AbXJ3UFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:05:44 -0400
Date: Tue, 30 Oct 2007 21:05:43 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Woodhouse <dwmw2@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, bernie@codewiz.org
Subject: Re: [PATCH] Allow auto-destruction of loop devices.
In-Reply-To: <20071030130137.3345ae43.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710302104020.31325@fbirervta.pbzchgretzou.qr>
References: <1193612911.2915.80.camel@shinybook.infradead.org>
 <20071030130137.3345ae43.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 30 2007 13:01, Andrew Morton wrote:
>On Sun, 28 Oct 2007 19:08:31 -0400
>David Woodhouse <dwmw2@infradead.org> wrote:
>
>> This allows a flag to be set on loop devices so that when they are
>> closed for the last time, they'll self-destruct.
>> 
>
>Why do we want to do this?

Off the top of my head, lazy unmounting comes to mind.
Think of this:

	mount foobar /mnt -o loop;
	cd /mnt;
	umount /mnt;

Currently, this leaves /dev/loop0 assigned, either chewing up loop
places or needlessy exposing objects meant to be rather not
accessible. (Think cryptoloop devices -- and pam_mount.) BTW, such a
flag would also really be useful for dm(-crypt).

