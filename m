Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYCZWpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYCZWpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbYCZWp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:45:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50530 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbYCZWp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:45:28 -0400
Date: Wed, 26 Mar 2008 22:44:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/7] vfs: mountinfo: add /proc/<pid>/mountinfo
Message-ID: <20080326224455.GV10722@ZenIV.linux.org.uk>
References: <20080326211131.705321084@szeredi.hu> <20080326212143.479034123@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326212143.479034123@szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 10:11:37PM +0100, Miklos Szeredi wrote:

> +This file contains lines of the form:
> +
> +36 35 98:0 /mnt1 /mnt2 rw,noatime rw master:1 - ext3 /dev/root,errors=continue
> +(1)(2)(3)   (4)   (5)      (6)    (7)  (8)   (9) (10)   (11)      (12)
> +
> +(1) mount ID:  unique identifier of the mount (may be reused after umount)
> +(2) parent ID:  ID of parent (or of self for the top of the mount tree)
> +(3) major:minor:  value of st_dev for files on filesystem
> +(4) root:  root of the mount within the filesystem
> +(5) mount point:  mount point relative to the process's root
> +(6) mount options:  per mount options

> +(7) super options:  filesystem type independent, per super block options

Move that one past fs type, please.

> +(8) optional fields:  zero or more fields of the form "tag[:value]"
> +(9) separator:  marks the end of the optional fields
> +(10) filesystem type:  name of filesystem of the form "type[.subtype]"
> +(11) mount source:  filesystem specific information or "none"

I'm not even sure that we *want* "none" here, to be honest, but that's
a separate story...
