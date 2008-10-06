Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbYJFSZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbYJFSZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 14:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbYJFSZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 14:25:50 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:35872 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYJFSZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 14:25:49 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
Date: Mon, 6 Oct 2008 18:25:46 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <gcdl7a$en4$1@taverner.cs.berkeley.edu>
References: <20081001201116.GD12527@outflux.net> <20081003001616.GN10632@outflux.net> <87ej2untze.fsf@basil.nowhere.org> <20081006175038.GF10357@outflux.net>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1223317546 15076 128.32.168.222 (6 Oct 2008 18:25:46 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Mon, 6 Oct 2008 18:25:46 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook  wrote:
>On Mon, Oct 06, 2008 at 08:00:21AM +0200, Andi Kleen wrote:
>> While the basic idea is good using get_random_bytes() is not.
>> 
>> That eats precious cryptography strength entropy from the entropy
>> pool, which on many systems is not adequately fed. In those cases you
>> really only want to use it for real keys, not for lower grade
>> applications. The applications glibc wants to use this for do not
>> really require crypto strength entropy, just relatively unpredictable
>> randomness.
>
>We're already using get_random* for stack, heap, and brk.  Also,
>get_random* uses the nonblocking pool, so this is the same as if userspace
>had tried to pull bytes out of /dev/urandom, which (as I understand it)
>is the very thing we're trying to duplicate without the VFS overhead.

Using /dev/urandom does seem like exactly the right thing to do.
(Andi Kleen's criticisms would be relevant if get_random_bytes() acted
like reading from /dev/random.)

I don't think it would be wise to use less than crypto strength
pseudorandom numbers for glibc -- at least, not without very thorough
analysis.  glibc is using this for security, so it has to be right.
When people say "oh, we don't need crypto-strength randomness", in
my experience it's too common to end up with something insecure.
