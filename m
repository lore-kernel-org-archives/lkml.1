Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbYK3Nl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbYK3Nl1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 08:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYK3NlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 08:41:15 -0500
Received: from ik-out-1112.google.com ([66.249.90.182]:21619 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbYK3NlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 08:41:13 -0500
Message-ID: <ac3eb2510811300541t660b7a9fsd44f5634cbd8028b@mail.gmail.com>
Date: Sun, 30 Nov 2008 14:41:11 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] fix pktcdvd breakage from commit e105b8bfc769b0545b6f0f395179d1e43cbee822
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, gregkh@suse.de,
       petero2@telia.com, linux-kernel@vger.kernel.org
In-Reply-To: <20081130133229.GZ28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081130121909.GV28946@ZenIV.linux.org.uk>
	 <ac3eb2510811300441m2a551cc7nec0374bb7a707bb8@mail.gmail.com>
	 <20081130132118.GY28946@ZenIV.linux.org.uk>
	 <ac3eb2510811300525n2e47ccap65e897ac1c4adab5@mail.gmail.com>
	 <20081130133229.GZ28946@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2008 at 14:32, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Nov 30, 2008 at 02:25:43PM +0100, Kay Sievers wrote:
>
>> Pktcdvd creates char _and_ block device nodes at the same time, while
>> the char nodes are not allocated, but created and conflict in
>> /sys/dev/ with properly allocated ones from other subsystems. Your
>> patch just papers over this bug.
>
> Where the hell is it creating any char device nodes?  Show me.

Here the hell it is:
  pd->dev = device_create(class_pktcdvd, NULL, pd->pkt_dev, NULL,
"%s", pd->name);

The bogus "pkt_dev", it's a char dev_t value, but because the char
dev_t value is already validly used by other subsystems, it will cause
the broken /sys/dev/ link. That's the real bug.

Kay
