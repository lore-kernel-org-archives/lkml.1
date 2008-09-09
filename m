Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYIIRul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYIIRul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 13:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYIIRuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 13:50:32 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59457 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYIIRuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 13:50:32 -0400
Subject: Re: [RFC v4][PATCH 9/9] File descriprtors (restore)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <1220946154-15174-10-git-send-email-orenl@cs.columbia.edu>
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>
	 <1220946154-15174-10-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain
Date: Tue, 09 Sep 2008 09:26:20 -0700
Message-Id: <1220977581.23386.216.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 03:42 -0400, Oren Laadan wrote:
> 
> +static int cr_close_all_fds(struct files_struct *files)
> +{
> +       int *fdtable;
> +       int n;
> +
> +       do {
> +               n = cr_scan_fds(files, &fdtable);
> +               if (n < 0)
> +                       return n;
> +               while (n--)
> +                       sys_close(fdtable[n]);
> +               kfree(fdtable);
> +       } while (n != -1);
> +
> +       return 0;
> +}

This needs to use an ERR_PTR().  It will save using the double-pointer.

-- Dave

