Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab0BGH5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 02:57:22 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48100 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab0BGH5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 02:57:20 -0500
Date: Sun, 7 Feb 2010 07:56:58 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Xiaotian Feng <dfeng@redhat.com>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       serue@linux.vnet.ibm.com, Eugene Teo <eugene@redhat.com>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [GIT][IMA] fix null pointer deref
Message-ID: <20100207075658.GF30031@ZenIV.linux.org.uk>
References: <1265364881-8140-1-git-send-email-dfeng@redhat.com>
 <OFD4EDD9E8.3C38BC7C-ON852576C1.004B1271-852576C1.004BCFCC@us.ibm.com>
 <alpine.LRH.2.00.1002071832080.21000@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1002071832080.21000@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 07, 2010 at 06:34:51PM +1100, James Morris wrote:
> Linus,
> 
> Please pull this bugfix.  I've verified that it fixes the null pointer 
> deref.

NAK.  In that form it's simply wrong; we should never get there with
NULL file->f_dentry->d_inode at all.  This is papering over the real
bug; I'll post a saner fix shortly.

The real problem is BS hiding of ima_file_free() inside a hook, with
condition that kinda-sorta happens to avoid bogus call most of the
time.

ima_path_check() side is also of BUG_ON() variety (and isn't triggered).
