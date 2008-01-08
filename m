Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYAHXTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYAHXTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:19:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYAHXSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:18:52 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56560 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752519AbYAHXSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:18:51 -0500
Date: Tue, 8 Jan 2008 17:18:48 -0600 (CST)
From: Brent Casavant <bcasavan@sgi.com>
Reply-To: Brent Casavant <bcasavan@sgi.com>
To: Tom Spink <tspink@gmail.com>
cc: Rick Jones <rick.jones2@hp.com>, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: AF_UNIX MSG_PEEK bug?
In-Reply-To: <7b9198260801081453s198af7efycc7c35668c65eaf1@mail.gmail.com>
Message-ID: <alpine.BSF.1.00.0801081716010.24286@pkunk.americas.sgi.com>
References: <alpine.BSF.1.00.0801081556580.24286@pkunk.americas.sgi.com>  <4783FBD6.1000004@hp.com> <7b9198260801081453s198af7efycc7c35668c65eaf1@mail.gmail.com>
User-Agent: Alpine 1.00 (BSF 882 2007-12-20)
Organization: "Silicon Graphics, Inc."
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008, Tom Spink wrote:

> Where in the code is the message length being sent across the socket?

In do_producer(), there are the following lines in the main loop:

	/* Send random lengths of data */
	messages[i].length = (rand() % MAXLEN) + sizeof(size_t);
	iov[i].iov_len = messages[i].length;

The entire "struct sockmsg" is sent across the socket, so the first
size_t in each message contains the length of the entire message
(including the size_t).  This size gets picked up at the
recv(...,MSG_PEEK) line in do_consumer().

Thanks,
Brent

-- 
Brent Casavant                          All music is folk music.  I ain't
bcasavan@sgi.com                        never heard a horse sing a song.
Silicon Graphics, Inc.                    -- Louis Armstrong
