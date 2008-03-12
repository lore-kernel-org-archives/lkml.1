Return-Path: <linux-kernel-owner+w=401wt.eu-S1752137AbYCKXU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbYCKXU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 19:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbYCKXUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 19:20:17 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:44194
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbYCKXUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 19:20:16 -0400
Message-ID: <47D721A8.10300@microgate.com>
Date: Tue, 11 Mar 2008 18:19:52 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: rupesh.sugathan@gmail.com
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][PATCH] n_tty : Loss of sync following a buffer overflow
References: <1205268139.29731.0.camel@estonia>
In-Reply-To: <1205268139.29731.0.camel@estonia>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rupesh Sugathan wrote:
> There seems to be a synchronization issue with the n_tty.c driver when
> working in canonical mode.
> The n_tty rightly discards data received following a buffer overflow and
> hence the tty->read_cnt is not updated. However, the newline characters
> received following a buffer overflow seems to increment the tty-
> canon_data index. This may result in a loss of sync between the tty-
> canon_data & tty->read_cnt while processing read in the read_chan().
> This loss of sync might be irrecoverable even when the data is later
> received at a slower rate.
> 
> ----
> I am not very sure if there is any deliberate rationale to process the
> newlines even when the buffer has overflown. Please comment and review
> the patch
> 
> diff -pu a/drivers/char/n_tty.c b/drivers/char/n_tty.c

Some more information:

This is not purely theoretical. Rupesh is actually
working a problem where he has seen the N_TTY buffer overflow
and the canonical state variables get out of sync with read_cnt, etc.

This patch seems obviously correct, if N_TTY drops a
char due to a full buffer the rest of the character
processing should not take place. Particularly in this
case where the extra processing leaves the tty structure
in an inconsistent state.

--
Paul Fulghum
Microgate Systems, Ltd



