Return-Path: <linux-kernel-owner+w=401wt.eu-S1760160AbZA3AUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160AbZA3AUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 19:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbZA3AUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 19:20:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753246AbZA3AUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 19:20:45 -0500
Date: Thu, 29 Jan 2009 16:19:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fweisbec@gmail.com
Subject: Re: [PATCH] tracing/ftrace: add an option to not print the context
 info for events
Message-Id: <20090129161956.9158e9c6.akpm@linux-foundation.org>
In-Reply-To: <497671d4.1358560a.7a83.6114@mx.google.com>
References: <497671d4.1358560a.7a83.6114@mx.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2009 16:52:36 -0800 (PST)
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> +		usec_rem = do_div(t, 1000000ULL);

The second argument to do_div() is in fact a u32.  It's quite hard to
track this down due to use of macros and lack of comemnts.

Doing

	usec_rem = do_div(t, USEC_PER_SEC);

would suit here.
