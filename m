Return-Path: <linux-kernel-owner+w=401wt.eu-S933618AbZLFAQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618AbZLFAQl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 19:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932982AbZLFAQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 19:16:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53256 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932957AbZLFAQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 19:16:38 -0500
Message-ID: <4B1AF856.6040305@gmail.com>
Date: Sun, 06 Dec 2009 01:18:30 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/31] Constify struct address_space_operations for	2.6.32
 v1
References: <4B198670.2000406@gmail.com> <4B198849.1060909@gmail.com> <20091205000845.GB9482@parisc-linux.org> <4B19AB28.6060805@gmail.com> <20091205142729.GC9482@parisc-linux.org>
In-Reply-To: <20091205142729.GC9482@parisc-linux.org>
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

Matthew Wilcox wrote:
> On Sat, Dec 05, 2009 at 01:36:56AM +0100, Emese Revfy wrote:
>> Matthew Wilcox wrote:
>>> On Fri, Dec 04, 2009 at 11:08:09PM +0100, Emese Revfy wrote:
>>>> -	int (*writepage)(struct page *page, struct writeback_control *wbc);
>>>> +	int (* const writepage)(struct page *page, struct writeback_control *wbc);
>>> Umm.  What effect does this have?
>>> What changes as a result of this patch?
>> My idea was that since all variables of this type are const, we might
>> as well have the compiler enforce it for the future if you think that
>> these fields should not be writable at all.
> 
> The compiler does already enforce it.  We do it like this:
> 
> struct address_space {
>         const struct address_space_operations *a_ops;   /* methods */
> }

This only ensures that the address_space_operations structure cannot be
written through a_ops, but the address_space_operations structure itself
can still be writable. My patch fixes the latter issue.
--
Emese

