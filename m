Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbZESAO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbZESAO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 20:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZESAOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 20:14:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39193 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbZESAOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 20:14:19 -0400
Message-ID: <4A11F997.5030602@redhat.com>
Date: Tue, 19 May 2009 08:13:11 +0800
From: Eugene Teo <eugene@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Frank Filz <ffilzlnx@us.ibm.com>
CC: NFS List <linux-nfs@vger.kernel.org>,
       NFS V4 Mailing List <nfsv4@linux-nfs.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       security@kernel.org, Trond Myklebust <trond.myklebust@fys.uio.no>,
       Bruce Fields <bfields@fieldses.org>
Subject: Re: [PATCH] nfs: Fix NFS v4 client handling of MAY_EXEC in 	nfs_permission.
References: <1242674983.4273.8.camel@dyn9047022153>
In-Reply-To: <1242674983.4273.8.camel@dyn9047022153>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Filz wrote:
> Sorry for the resend, got lkml address wrong...
> 
> The problem is that permission checking is skipped if atomic open is
> possible, but when exec opens a file, it just opens it O_READONLY which
> means EXEC permission will not be checked at that time.
> 
> This problem is observed by the following sequence (executed as root):
> 
> mount -t nfs4 server:/ /mnt4
> echo "ls" >/mnt4/foo
> chmod 744 /mnt4/foo
> su guest -c "mnt4/foo"
> 
> Signed-off-by: Frank Filz <ffilzlnx@us.ibm.com>

Tested-by: Eugene Teo <eugeneteo@kernel.sg>

Thanks, Eugene
