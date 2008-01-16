Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYAPXMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYAPXMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYAPXMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:12:09 -0500
Received: from saeurebad.de ([85.214.36.134]:37416 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbYAPXMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:12:07 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
References: <87lk6pvii0.fsf@saeurebad.de>
	<alpine.LFD.1.00.0801161026550.2806@woody.linux-foundation.org>
	<87odblct19.fsf@saeurebad.de>
	<Pine.LNX.4.64.0801161419290.11922@schroedinger.engr.sgi.com>
Date: Thu, 17 Jan 2008 00:13:04 +0100
In-Reply-To: <Pine.LNX.4.64.0801161419290.11922@schroedinger.engr.sgi.com>
	(Christoph Lameter's message of "Wed, 16 Jan 2008 14:20:50 -0800
	(PST)")
Message-ID: <87bq7lcqke.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Christoph Lameter <clameter@sgi.com> writes:

> On Wed, 16 Jan 2008, Johannes Weiner wrote:
>
>> So if I got it right and you actually modify the memory you only got a
>> const pointer to, you reach a level where you _have to_ break this
>> policy and cast to a non-const pointer, as it is currently done in
>> kfree().  No?
>
> Correct and we have gcc 4.2 currently spitting out warnings because of 
> casting to non const. Any idea how to convince gcc that this is okay?

Just for the record, this really seems to be a gcc bug, I can not
explain this otherwise:

$ cat test.c
#include <stdio.h>

static void test(void *p)
{
        char *v = p;
        puts(v);
}

int main(void)
{
        const char foo[] = "foo";
        test((void *)foo);
        return 0;
}
$ gcc -Wall test.c -o test
$ gcc -Wall -O test.c -o test
test.c: In function 'main':
test.c:12: warning: passing argument 1 of 'test' discards qualifiers from pointer target type
$ gcc -Wall -O -fno-inline test.c -o test
$

gcc is version 4.2.2.

	Hannes
