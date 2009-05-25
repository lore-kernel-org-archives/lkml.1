Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011AbZEYAMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbZEYAMR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 20:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZEYAMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 20:12:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43035 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbZEYAMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 20:12:03 -0400
Date: Mon, 25 May 2009 02:07:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       roland@redhat.com, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] signal: make group kill signal fatal
Message-ID: <20090525000750.GA2301@redhat.com>
References: <1243198054-13816-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243198054-13816-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24, Jiri Slaby wrote:
>
> __fatal_signal_pending() returns now true only for a non-group sent
> sigkill, i. e. for example tgkill, send_sig...

No. Please look at complete_signal(). If we queue a fatal signal,
we always add SIGKILL to any thread.

> Use sigkill_pending()

Please do not use it, it should die.

> in __fatal_signal_pending() which adds a test also
> for shared_pending queue.

See above. Afaics this is not needed.

> Also grab siglock in __fatal_signal_pending().

This is wrong. It can be called when the task has already died
and its ->signal == NULL.

Oleg.

