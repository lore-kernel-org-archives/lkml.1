Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZGBOEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZGBOEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 10:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZGBOD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 10:03:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59457 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbZGBOD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 10:03:56 -0400
Message-ID: <4A4CBD4E.90802@RedHat.com>
Date: Thu, 02 Jul 2009 09:59:42 -0400
From: Steve Dickson <SteveD@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: bfields@fieldses.org, rasmus@msconsult.dk, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFSD: Don't hold unrefcounted creds over call to	nfsd_setuser()
References: <20090702133532.28297.89635.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090702133532.28297.89635.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/02/2009 09:35 AM, David Howells wrote:
> nfsd_open() gets an unrefcounted pointer to the current process's effective
> credentials at the top of the function, then calls nfsd_setuser() via
> fh_verify() - which may replace and destroy the current process's effective
> credentials - and then passes the unrefcounted pointer to dentry_open() - but
> the credentials may have been destroyed by this point.
> 
> Instead, the value from current_cred() should be passed directly to
> dentry_open() as one of its arguments, rather than being cached in a variable.
> 
> Possibly fh_verify() should return the creds to use.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Tested-and-Verified-By: Steve Dickson <steved@redhat.com>
