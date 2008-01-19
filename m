Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbYASW1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbYASW1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 17:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbYASW1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 17:27:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53915 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYASW1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 17:27:07 -0500
Date: Sat, 19 Jan 2008 23:30:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steve French <smfrench@gmail.com>
Cc: simo <idra@samba.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org,
       samba-technical@lists.samba.org
Subject: Re: [linux-cifs-client] [PATCH] Remove information leak in Linux CIFS clientg
Message-ID: <20080119223029.GA5786@one.firstfloor.org>
References: <20080119045552.GA11134@basil.nowhere.org> <1200730722.28706.70.camel@localhost.localdomain> <524f69650801191406j440e52afsb9b80efed4fa15da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524f69650801191406j440e52afsb9b80efed4fa15da@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2008 at 04:06:57PM -0600, Steve French wrote:
> The access denied message in the dmesg log reveals no more information
> than strace on stat of a local file does (which also returns access

You can't strace a process you don't own. And you might not be able
to access the directory below which the file is.

But there is no such access control on "dmesg". So if there is an
access error you leak the potentially protected information in 
the file name

> denied and displays access denied), but I agree that logging on
> -EACCESS on lookup does clutter the log.
> 
> I think it is ok to log a message on unexpected errors (for
> QueryPathInfo those would include anything other than ENOENT and
> EACCESS - Simo, can you think of others?)  I don't mind ratelimiting
> logging on this clause (for errors other than ENOENT and EACCESS) but
> it would complicate the code for a case I have not seen in the wild.
> 
> I prefer the following to remove the log cluttering on this case:

That would still be an information leak for other errors.

Logging the path would be only safe if you determine that the
file and all its parent directories were world read (and accessable)able,
but that would be probably difficult.

-Andi
