Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbZDTF0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbZDTF0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 01:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZDTF0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 01:26:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54986 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589AbZDTF0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 01:26:04 -0400
Message-ID: <49EC06D1.7030208@redhat.com>
Date: Mon, 20 Apr 2009 13:23:29 +0800
From: Eugene Teo <eugene@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: sfrench@us.ibm.com, chrisw@sous-sol.org, shirishp@us.ibm.com,
       stable@kernel.org, vinaysridhar@in.ibm.com,
       stable-commits@vger.kernel.org, Jeffrey Layton <jlayton@redhat.com>
Subject: Re: patch 0022-CIFS-Fix-memory-overwrite-when-saving-nativeFileSys.patch
 added to 2.6.27-stable tree
References: <20090418005257.1009549099@coco.kroah.org>
In-Reply-To: <20090418005257.1009549099@coco.kroah.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gregkh@suse.de wrote:
[...]
> From 15bd8021d870d2c4fbf8c16578d72d03cfddd3a7 Mon Sep 17 00:00:00 2001
> From: Steve French <sfrench@us.ibm.com>
> Date: Thu, 26 Mar 2009 23:05:15 +0000
> Subject: CIFS: Fix memory overwrite when saving nativeFileSystem field during mount
> 
> upstream commit: b363b3304bcf68c4541683b2eff70b29f0446a5b
> 
> CIFS can allocate a few bytes to little for the nativeFileSystem field
> during tree connect response processing during mount.  This can result
> in a "Redzone overwritten" message to be logged.

The same for 2.6.28-stable tree.

On top of commit b363b330, we need:
f083def6 - cifs: fix buffer size for tcon->nativeFileSystem field
22c9d52b - cifs: remove unnedded bcc_ptr update in CIFSTCon
and maybe this too:
313fecfa - cifs: add cFYI messages with some of the saved strings from
ssetup/tcon

There is no CVE name for this yet. Still waiting.

Thanks, Eugene
--
Eugene Teo / Red Hat Security Response Team
