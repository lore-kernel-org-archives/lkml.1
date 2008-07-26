Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbYGZD7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbYGZD7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 23:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYGZD7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 23:59:08 -0400
Received: from mercury.realtime.net ([205.238.132.86]:33769 "EHLO
	ruth.realtime.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751270AbYGZD7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 23:59:07 -0400
In-Reply-To: <200807251111.26673.jk@ozlabs.org>
References: <1216887460.306306.238738123378.1.gpush@pingu> <200807250108.m6P18f4B099179@sullivan.realtime.net> <200807251111.26673.jk@ozlabs.org>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <b15cc94f988df8d269ad40fafcd911cb@bga.com>
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
From: Milton Miller <miltonm@bga.com>
Subject: Re: [RFC,PATCH] scripts/package: add powerpc images to tarball
Date: Fri, 25 Jul 2008 22:59:06 -0500
To: Jeremy Kerr <jk@ozlabs.org>
X-Mailer: Apple Mail (2.624)
X-Originating-IP: 216.126.174.41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 24, 2008, at 8:11 PM, Jeremy Kerr wrote:

> Milton,
>
>> Yes.  How about all dtbImage, zImage, cuboot, treeboot, etc
>> that are newer than vmlinux?
>
> The existing arch code doesn't do any checks for timestamps, perhaps
> this would be better implemented as an arch-independent change?

The problem is some people might want to add intermediate files that are
younger than vmlinux (eg .config).  We know our boot-image should be
newer.  But I don't know how one would express the expected ages.

The reason I suggested the check was to eliminate images that are not
in the current config.  I figured a test for relative file age could
be done in the for loop -- possibly replace shell wildcard with
find arch/$(ARCH)/boot/{zImage*,dtbImage*,uImage*,cuImage*,treeboot*}
-newer vmlinux -print.

> (but would you like me to add treeboot and cuboot?)

I don't see why we should prefer the workstations and servers over the
embedded boards.  zImage is just a link to the first boot image, but
one can build a multiple formats and the order is somewhat arbitrary.
So I see it as fairness.  Otherwise, there are a few other platforms
that are "user" based vs embedded (like efkia, no?).

milton

