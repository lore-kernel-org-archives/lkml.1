Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbZFXHWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbZFXHWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZFXHWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:22:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38840 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZFXHWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:22:36 -0400
To: David Thomas <davidleothomas@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Magic Security Dust: Appropriating SECCOMP
From: Andi Kleen <andi@firstfloor.org>
References: <3a8893170906232205x18417861v446a2905a4ccf21@mail.gmail.com>
Date: Wed, 24 Jun 2009 09:22:38 +0200
In-Reply-To: <3a8893170906232205x18417861v446a2905a4ccf21@mail.gmail.com> (David Thomas's message of "Wed, 24 Jun 2009 01:05:30 -0400")
Message-ID: <874ou6kse9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Thomas <davidleothomas@gmail.com> writes:

Normally it's better if you post example patches, even
if they're unclean. 

> Moving the checks from the audit/trace code out to the
> individual syscalls means that each syscall we're doing one

Not sure that's a good idea. It would be lot of code churn
all over the tree and risk of not covering some new syscalls.

What I would do if I wanted a more flexible seccomp is to have a
"one bit for each syscall" bitmap (or rather two one for compat
another for non compat) that is checked by the audit code
and then just check all syscalls against that big bitmap.
Then have some way to configure that bitmap for groups
of processes.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
