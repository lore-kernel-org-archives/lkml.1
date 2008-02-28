Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbYB1Qon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbYB1Qon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757477AbYB1Qog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:44:36 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:48852 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757326AbYB1Qof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:44:35 -0500
Date: Thu, 28 Feb 2008 17:44:30 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
Subject: Re: hfsplus_unlink...hfsplus_block_free: lockdep warning
In-Reply-To: <1204211750.12120.2.camel@twins>
Message-ID: <Pine.LNX.4.64.0802281731520.2723@scrub.home>
References: <tkrat.9bcd69644c113f6d@s5r6.in-berlin.de> <1204211750.12120.2.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 28 Feb 2008, Peter Zijlstra wrote:

> > Is this merely a case for annotation?
> 
> Being utterly clueless on HFS, and not having had a look yet, I'd say
> its genuine. Esp. since the i_mutex lock class is per filesystem type.
> 
> So HFS has internal lock ordering problems, its not interaction with
> another filesystem - like we used to have with ext vs the pseudo
> filesystems.

Please look at the code before you get to such conclusions...
The allocation bitmap is very much organized like a normal file, so HFS+ 
treats it like a file (e.g. its data is in the page cache), this file is 
just not visible outside HFS+, so I used the inode lock to synchronize the 
access to it. The lock ordering should be fine, lockdep just doesn't know 
about it.

bye, Roman
