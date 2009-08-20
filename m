Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbZHTKCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbZHTKCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbZHTKCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:02:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbZHTKCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:02:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090819163616.3716.18477.stgit@localhost.localdomain>
References: <20090819163616.3716.18477.stgit@localhost.localdomain>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] bsdacct: switch credentials for writing to the accounting file
Date: Thu, 20 Aug 2009 11:02:06 +0100
Message-ID: <17328.1250762526@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Schmidt <mschmidt@redhat.com> wrote:

> When process accounting is enabled, every exiting process writes a log
> to the account file. In addition, every once in a while one of the
> exiting processes checks whether there's enough free space for the log.
> 
> SELinux policy may or may not allow the exiting process to stat the fs.
> So unsuspecting processes start generating AVC denials just because
> someone enabled process accounting.
> 
> For these filesystem operations, the exiting process's credentials
> should be temporarily switched to that of the process which enabled
> accounting, because it's really that process who wanted to have the
> accounting information logged.
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

Do you really need to keep creds in acct?  Can you used acct->file->f_cred
instead?  Those are the credentials of the process that opened the file, so
acct->cred may be redundant.

Other than that, it looks reasonable.

David
