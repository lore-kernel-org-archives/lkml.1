Return-Path: <linux-kernel-owner+w=401wt.eu-S2992848AbXDYQ61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992848AbXDYQ61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 12:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992842AbXDYQ61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 12:58:27 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57726 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992829AbXDYQ60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 12:58:26 -0400
Message-ID: <462F87EA.1000002@zytor.com>
Date: Wed, 25 Apr 2007 09:55:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, ebiederm@xmission.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch] unprivileged mounts update
References: <E1HgcBv-00049Z-00@dorka.pomaz.szeredi.hu> <E1HgjG0-0005CN-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1HgjG0-0005CN-00@dorka.pomaz.szeredi.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> 
> Andrew, please skip this patch, for now.
> 
> Serge found a problem with the fsuid approach: setfsuid(nonzero) will
> remove filesystem related capabilities.  So even if root is trying to
> set the "user=UID" flag on a mount, access to the target (and in case
> of bind, the source) is checked with user privileges.
> 
> Root should be able to set this flag on any mountpoint, _regardless_
> of permissions.
> 

Right, if you're using fsuid != 0, you're not running as root (fsuid is
the equivalent to euid for the filesystem.)

I fail to see how ruid should have *any* impact on mount(2).  That seems
to be a design flaw.

	-hpa
