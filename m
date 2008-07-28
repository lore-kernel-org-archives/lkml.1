Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbYG1Kwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbYG1Kwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 06:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYG1KwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 06:52:24 -0400
Received: from pond.fysh.org ([166.84.7.109]:44064 "EHLO pond.fysh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYG1KwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 06:52:23 -0400
Date: Mon, 28 Jul 2008 11:52:22 +0100
From: Athanasius <link@miggy.org>
To: Reg Clemens <reg@dwf.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Confused: 'tail -f' how can this happen???
Message-ID: <20080728105222.GB17871@miggy.org>
Mail-Followup-To: Reg Clemens <reg@dwf.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <200807252137.m6PLbAkj008998@deneb.dwf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807252137.m6PLbAkj008998@deneb.dwf.com>
X-gpg-fingerprint: E218CE1D
X-gpg-key: http://www.fysh.org/~athan/gpg-key
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 03:37:10PM -0600, Reg Clemens wrote:
> OK, I dont understand this at all.
> I was debugging another problem, and had a 'tail -f' running on my maillog 
> file.
> It showed data down to the  present, namely 15:18:18

  What date ?

> Something had gone by fast enough that I brought the maillog up in an editor
> but IT only showed data down to 14:02:16

  And what date here ?

> Looking at the 'ls' of /var/log, the maillog file shows a write date of 14:02.
> 
> If I do a 2nd tail -f, it too stops at 14:02.

  And here ?

> What is going on with the file system to cause the bizare behaviour?
> Why cant I see ALL the data in maillog, or why could I see it only once?
> 
> Confused.

   I'm hoping this is as simple as:

	1) You opened the initial tail on one day and left it running
	2) Log rotation happens, mail software, via syslog or directly,
	starts logging to the new 'maillog', the other one now being
	'maillog.1' or whatever
	3) You don't realise this and get confused by the differing data
	when you look afresh at what is now 'maillog'

And of course, depending on local configuration, maybe your maillog
rotates more often than once a day (although that alone wouldn't explain
the 'gone backwards' timestamp).

HTH,

-Ath
-- 
- Athanasius = Athanasius(at)miggy.org / http://www.miggy.org/
                  Finger athan(at)fysh.org for PGP key
	   "And it's me who is my enemy. Me who beats me up.
Me who makes the monsters. Me who strips my confidence." Paula Cole - ME
