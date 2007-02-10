Return-Path: <linux-kernel-owner+w=401wt.eu-S1423359AbXBJABF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423359AbXBJABF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 19:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423368AbXBJABE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 19:01:04 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:55652 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423359AbXBJABD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 19:01:03 -0500
Subject: Re: [PATCH 21/22] honor r/w changes at do_remount() time
From: Dave Hansen <hansendc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
In-Reply-To: <20070209152219.fa61d152.akpm@linux-foundation.org>
References: <20070209225329.27619A62@localhost.localdomain>
	 <20070209225344.93A75D35@localhost.localdomain>
	 <20070209152219.fa61d152.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 16:00:57 -0800
Message-Id: <1171065657.24675.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 15:22 -0800, Andrew Morton wrote:
> On Fri, 09 Feb 2007 14:53:44 -0800
> Dave Hansen <hansendc@us.ibm.com> wrote:
> 
> > This is the core of the read-only bind mount patch set.
> 
> Who wants read-only bind mounts, and for what reason?

The original desire came out of the linux-vserver project.  It allows a
sysadmin to share directories between many vservers/containers and keep
those containers from writing to it, even though the users in that
vserver may have "root" privileges.

This also has the advantage of cleaning up the somewhat hackish "look
for writable-open-files during remount/ro operations".  It should also
allow us to separate the concepts of the user wanting a filesystem to be
r/o and the filesystem _itself_ being r/o because of a r/o device or
some kind of corruption.

-- Dave

