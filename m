Return-Path: <linux-kernel-owner+w=401wt.eu-S1030227AbXAZOu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030227AbXAZOu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 09:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030638AbXAZOu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 09:50:57 -0500
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:43516
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030227AbXAZOu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 09:50:56 -0500
Message-ID: <45BA1556.8080808@microgate.com>
Date: Fri, 26 Jan 2007 08:51:02 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: Strange problem with tty layer
References: <20070124204009.GA7584@csclub.uwaterloo.ca> <45B7CDB5.7020909@microgate.com> <20070125151639.GH7582@csclub.uwaterloo.ca> <20070126142041.GD7584@csclub.uwaterloo.ca>
In-Reply-To: <20070126142041.GD7584@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> Well it turns out that didn't help.  Neither does 2.6.18 (that one was
> the easiest newer one to try).  It does seem as if the error rate is
> lower with 2.6.18 than with 2.6.16, so perhaps there was more than one
> place that could cause losses in the tty buffering.  I had only 2
> failures in 15 hours with 2.6.18, rather than a whole lot of failures
> with 2.6.16.  I guess I will have to try 2.6.19 or even something newer.

You can eliminate the tty buffering altogether
by observing what gets passed to the line discipline.

I assume you are using the default line discipline N_TTY.

Look at what is passed to drivers/char/n_tty.c:n_tty_receive_buf()
If all the data gets that far, then there is some issue
with the line discipline or something further downstream.
If not, then the problem is with the tty buffering (assuming
you are correct that all data gets to the tty buffering code
followed by a tty_flip_buffer_push call).

-- 
Paul Fulghum
Microgate Systems, Ltd.
