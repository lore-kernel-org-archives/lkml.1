Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbZEDHN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbZEDHN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 03:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbZEDHNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 03:13:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39632 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbZEDHNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 03:13:16 -0400
To: Elad Lahav <elahav@uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Implementation of the sendgroup() system call
From: Andi Kleen <andi@firstfloor.org>
References: <49FE47A1.7070700@uwaterloo.ca>
Date: Mon, 04 May 2009 09:13:10 +0200
In-Reply-To: <49FE47A1.7070700@uwaterloo.ca> (Elad Lahav's message of "Sun, 03 May 2009 21:40:49 -0400")
Message-ID: <87eiv5ibnd.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elad Lahav <elahav@uwaterloo.ca> writes:

> The attached patch contains an implementation of sendgroup(), a system
> call that allows a UDP packet to be transmitted efficiently to
> multiple recipients. Use cases for this system call include
> live-streaming and multi-player online games.
> The basic idea is that the caller maintains a group - a list of IP
> addresses and UDP ports - and calls sendgroup() with the group list
> and a common payload. Optionally, the call allows for per-recipient
> data to be prepended or appended to the shared block. The data is
> copied once in the kernel into an allocated page, and the
> per-recipient socket buffers point to that page. Savings come from
> avoiding both the multiple calls and the multiple copies of the data
> required with regular socket operations.

My guess it's more the copies than the calls? It sounds like
you want sendfile() for UDP. I think that would be a cleaner solution
than such a specific hack for your application. It would
have the advantage of saving the first copy too and be 
truly zero copy on capable NICs.

Or perhaps simple send to a local multicast group and let
some netfilter module turn that into regular UDP.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
