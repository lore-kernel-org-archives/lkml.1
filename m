Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbYJ0J6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbYJ0J6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 05:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYJ0J6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 05:58:47 -0400
Received: from smtp4.netcologne.de ([194.8.194.137]:41670 "EHLO
	smtp4.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbYJ0J6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 05:58:46 -0400
Date: Mon, 27 Oct 2008 10:58:43 +0100
From: Max Kellermann <max@duempel.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: High load in 2.6.27, NFS / rpcauth_lookup_credcache()?
Message-ID: <20081027095843.GA10937@squirrel.roonstrasse.net>
Mail-Followup-To: Trond Myklebust <trond.myklebust@fys.uio.no>,
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
References: <20081022091207.GA12996@squirrel.roonstrasse.net> <20081023123628.GA18549@squirrel.roonstrasse.net> <1224773745.7625.4.camel@localhost> <20081024083913.GA15197@squirrel.roonstrasse.net> <1224871763.22672.33.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224871763.22672.33.camel@localhost>
X-Terrorism: FBI NSA CIA Clinton Bush Blair Urane Nuclear Bomb Terror
	Hussein Iraq Iran Syria Plutonium Bin Laden World Trade Center
	Afghanistan Taliban Jaish Rocket Guantanamo Ziercke
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008/10/24 20:09, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> OK, could you please describe your environment a bit. Do you have lots
> of different users logged in at the same time, or do you perhaps use
> newgrp or su to switch uid/gids a lot on your processes?
> I'm trying to see if there might be a reason for the lookup in the
> credcache being such a heavy duty operation in your setup.

It's a web server for shared hosting.  The web space is mounted via
NFSv3 from a NetApp.  There is a huge number of web sites on this
cluster.  All web sites are owned by the same UID, and the web server
runs as a different UID (read-only access).

Each time a CGI starts, its uid is changed to the one "owner" UID
(similar to mod_suexec, but there's only one UID for all customer
accounts).  Each time a CGI starts, its chroot (pivot_root) is
constructed with several bind mounts (in a separate namespace with
CLONE_NEWNS).

There are no new users or groups being created.  There are only 2 UIDs
accessing NFS: the webserver (ro) and CGI (rw).

Max
