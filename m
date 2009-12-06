Return-Path: <linux-kernel-owner+w=401wt.eu-S933799AbZLFOWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933799AbZLFOWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 09:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933637AbZLFOWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 09:22:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50999 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933736AbZLFOWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 09:22:21 -0500
Message-ID: <4B1BBE71.70305@gmail.com>
Date: Sun, 06 Dec 2009 15:23:45 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/31] Constify struct super_operations for 2.6.32 v1
References: <b6fcc0a0912052114v790f04c9h9a7367ff74d12426@mail.gmail.com>
In-Reply-To: <b6fcc0a0912052114v790f04c9h9a7367ff74d12426@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
>> -   	struct inode *(*alloc_inode)(struct super_block *sb);
>> +   	struct inode *(* const alloc_inode)(struct super_block *sb);
> 
> Good rule is if adding const doesn't move object from one section
> to another, it isn't worth it.
> 
> I suggest we stick to it or risk another wave of jumbo patches.
> 
If all instances of a given ops structure are const and we would like to
preserve this policy for the future as well, then  it is very useful
to give future programmers a strong hint about this policy by making
the compiler complain about any violation attempts. Otherwise they may
very well write code that modifies such structures and we will have to
work extra to undo that (or change the policy but in that case it is
good to know why we have to do that).
--
Emese
