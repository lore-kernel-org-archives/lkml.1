Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbYGaREV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbYGaREV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 13:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbYGaREK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 13:04:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbYGaREJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 13:04:09 -0400
Date: Thu, 31 Jul 2008 10:00:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Miklos Szeredi <miklos@szeredi.hu>, jens.axboe@oracle.com,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch v3] splice: fix race with page invalidation
In-Reply-To: <200807312259.43402.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.1.10.0807310957200.3277@nehalem.linux-foundation.org>
References: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu> <200807312259.43402.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 Jul 2008, Nick Piggin wrote:
> 
> It seems like the right way to fix this would be to allow the splicing
> process to be notified of a short read, in which case it could try to
> refill the pipe with the unread bytes...

Hmm. That should certainly work with the splice model. The users of the 
data wouldn't eat (or ignore) the invalid data, they'd just say "invalid 
data", and stop. And it would be up to the other side to handle it (it 
can see the state of the pipe, we can make it both wake up POLL_ERR _and_ 
return an error if somebody tries to write to a "blocked" pipe).

So yes, that's very possible, but it obviously requires splice() users to 
be able to handle more cases. I'm not sure it's realistic to expect users 
to be that advanced.

		Linus
