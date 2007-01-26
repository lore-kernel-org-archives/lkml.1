Return-Path: <linux-kernel-owner+w=401wt.eu-S1030681AbXAZO4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030681AbXAZO4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 09:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030705AbXAZO4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 09:56:11 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:34518 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030681AbXAZO4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 09:56:10 -0500
Date: Fri, 26 Jan 2007 09:56:08 -0500
To: Paul Fulghum <paulkf@microgate.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange problem with tty layer
Message-ID: <20070126145608.GK7582@csclub.uwaterloo.ca>
References: <20070124204009.GA7584@csclub.uwaterloo.ca> <45B7CDB5.7020909@microgate.com> <20070125151639.GH7582@csclub.uwaterloo.ca> <20070126142041.GD7584@csclub.uwaterloo.ca> <45BA1556.8080808@microgate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BA1556.8080808@microgate.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 08:51:02AM -0600, Paul Fulghum wrote:
> You can eliminate the tty buffering altogether
> by observing what gets passed to the line discipline.

I will have to find where in the code that is happening.

> I assume you are using the default line discipline N_TTY.
> 
> Look at what is passed to drivers/char/n_tty.c:n_tty_receive_buf()
> If all the data gets that far, then there is some issue
> with the line discipline or something further downstream.
> If not, then the problem is with the tty buffering (assuming
> you are correct that all data gets to the tty buffering code
> followed by a tty_flip_buffer_push call).

I am not sure actually.  I just open /dev/ttyn0 and /dev/ttyn1 and write
to one, and read from the other.  I didn't even know about the line
diciplines actually.  How do I tell which one I am using?

I have confirmed that all the data is being passed to
tty_insert_flip_string() in jsm_input().

--
Len Sorensen
