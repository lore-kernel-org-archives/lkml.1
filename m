Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbZE3Dyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbZE3Dyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 23:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbZE3Dyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 23:54:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754740AbZE3Dyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 23:54:37 -0400
Date: Fri, 29 May 2009 20:54:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vvscore@gmail.com
Subject: Re: [PATCH] 8250: Fix oops from setserial
Message-Id: <20090529205429.c9c73b19.akpm@linux-foundation.org>
In-Reply-To: <20090528130132.19582.65165.stgit@t61.ukuu.org.uk>
References: <20090528130132.19582.65165.stgit@t61.ukuu.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 14:01:35 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@linux.intel.com>
> 
> [Impact: ok I just put this here to wind up Linus]
> 
> If you setserial a port which has never been initialised we change the type
> but don't update the I/O method pointers. The same problem is true if you
> change the io type of a port - but nobody ever does that so nobody noticed!
> 
> Remember the old type and when attaching if the type has changed reload the
> port accessor pointers. We can't do it blindly as some 8250 drivers load custom
> accessors and we must not stomp those.
> 
> Closes-bug: #13367

Please quote the full bug URL.

a) for consistency

b) because there are multiple bug tracking systems out there:

y:/usr/src/git26> git-log|grep bugzilla.redhat|wc -l
123

>  static void set_io_from_upio(struct uart_port *p)
>  {
> +	struct uart_8250_port *up = (struct uart_8250_port *)p;

container_of() is nicer, IMO.  It's clearer, and doesn't require that
the uart_port be the fist member.

