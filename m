Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbYJAHVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbYJAHVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYJAHUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:20:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:47303 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbYJAHUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:20:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vLSW/4632CVRESeV70yERc6D/kY1rzThweyUF1h19UnyANVt76XycJIbQR/RsNGgiI
         CJ8uGs4G2lTkW9irzm7TkFGTXgOO+dy8Qc9iNc1NzifTroYA5Ccz9CQKmIKleJ9HAWjd
         /7b8AnLv0E9M1EzbgCd8cKf8KY+GzfkF5adJc=
Message-ID: <c62985530810010020u1f3f44e1l6b8fb2f31c35d215@mail.gmail.com>
Date: Wed, 1 Oct 2008 09:20:52 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 0/2] ring_buffer: updates for linux-tip
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Pekka Paalanen" <pq@iki.fi>, "Martin Bligh" <mbligh@google.com>
In-Reply-To: <20081001042951.412019606@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081001042951.412019606@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/1 Steven Rostedt <rostedt@goodmis.org>:
> The first patch is just a lockdep clean up of the ring buffer.
>
> The next patch is a new locking design. It is not lockless (yet) but
> the locking is a bit cleaner than the original. The basic idea is
> that the reader now has its own page to read from that is not in
> the ring buffer. When the reader (a consumer) finishes a page, it
> then grabs a lock to pull out a new page from the ring buffer and
> replace it with the one that it just finished reading.

Good idea! Sounds a real saner approach.
