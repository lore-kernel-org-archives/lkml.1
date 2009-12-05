Return-Path: <linux-kernel-owner+w=401wt.eu-S932723AbZLEAe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723AbZLEAe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932609AbZLEAe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:34:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41075 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599AbZLEAe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:34:57 -0500
Message-ID: <4B19AB28.6060805@gmail.com>
Date: Sat, 05 Dec 2009 01:36:56 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/31] Constify struct address_space_operations for	2.6.32
 v1
References: <4B198670.2000406@gmail.com> <4B198849.1060909@gmail.com> <20091205000845.GB9482@parisc-linux.org>
In-Reply-To: <20091205000845.GB9482@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Fri, Dec 04, 2009 at 11:08:09PM +0100, Emese Revfy wrote:
>>  struct address_space_operations {
>> -	int (*writepage)(struct page *page, struct writeback_control *wbc);
>> -	int (*readpage)(struct file *, struct page *);
>> -	void (*sync_page)(struct page *);
>> +	int (* const writepage)(struct page *page, struct writeback_control *wbc);
>> +	int (* const readpage)(struct file *, struct page *);
>> +	void (* const sync_page)(struct page *);
> 
> Umm.  What effect does this have?
> What changes as a result of this patch?

My idea was that since all variables of this type are const, we might
as well have the compiler enforce it for the future if you think that
these fields should not be writable at all.

> Aren't functions implicitly constant?

They are, but these are function pointer fields in a structure, not
the functions themselves.

--
Emese


