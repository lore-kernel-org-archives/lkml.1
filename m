Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbYFTRzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbYFTRzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 13:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYFTRzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 13:55:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47089 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYFTRzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 13:55:08 -0400
Message-ID: <485BEEF7.2020404@firstfloor.org>
Date: Fri, 20 Jun 2008 19:55:03 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH, RFC] fasync() BKL pushdown
References: <20080620112914.783be428@bike.lwn.net>
In-Reply-To: <20080620112914.783be428@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:

> The majority of fasync() functions just call fasync_helper() with a pointer
> to an fasync_struct reachable from the file structure.  Given that (1) the
> struct file will not go away while fasync() is running, and (2) the
> VFS-level fasync() stuff is protected with the Big Fasync Lock, I contend
> that these simple implementations have no need for the BKL.  

Not necessarily true, they might require BKL still for fd live time issues.

-Andi

