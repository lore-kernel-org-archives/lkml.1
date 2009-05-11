Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbZEKB2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbZEKB2j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 21:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbZEKB2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 21:28:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58088 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZEKB23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 21:28:29 -0400
Date: Mon, 11 May 2009 02:28:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org
Subject: Re: Q. Switch open_exec() and sys_uselib() to do_open_filp()
Message-ID: <20090511012828.GH8633@ZenIV.linux.org.uk>
References: <29926.1242003317@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29926.1242003317@jrobl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 09:55:17AM +0900, hooanon05@yahoo.co.jp wrote:
> 
> By the commit 6e8341a11eb21826b7192d0bb88cb5b44900a9af
> "Switch open_exec() and sys_uselib() to do_open_filp()",
> FMODE_EXEC flag is passed to struct file. I have no objection nor
> question about that.
> 
> But it is set to file->f_flags instead of f_mode.
> Is this intended behaviour?

It is previously existing behaviour.  Check what path_lookup_open() does
and how had it used to be called.

And no, very little about intents makes any sense, including that part.
Call graph of the entire lookup-and-open-related machinery least of all.
So we have to untangle that mound of mating tapeworms, one by one ;-/
