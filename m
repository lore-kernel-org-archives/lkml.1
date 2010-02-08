Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620Ab0BHDmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 22:42:33 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44268 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757756Ab0BHDmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 22:42:31 -0500
In-Reply-To: <20100207075658.GF30031@ZenIV.linux.org.uk>
References: <1265364881-8140-1-git-send-email-dfeng@redhat.com> <OFD4EDD9E8.3C38BC7C-ON852576C1.004B1271-852576C1.004BCFCC@us.ibm.com> <alpine.LRH.2.00.1002071832080.21000@tundra.namei.org> <20100207075658.GF30031@ZenIV.linux.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Xiaotian Feng <dfeng@redhat.com>, Eric Paris <eparis@redhat.com>,
       Eugene Teo <eugene@redhat.com>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-security-module-owner@vger.kernel.org, serue@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [GIT][IMA] fix null pointer deref
X-KeepSent: 4ED37009:B78CBF20-852576C4:0012975E;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OF4ED37009.B78CBF20-ON852576C4.0012975E-852576C4.00145EA3@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Sun, 7 Feb 2010 22:42:29 -0500
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.5.1HF41 | October 22, 2009) at
 02/07/2010 22:42:29,
	Serialize complete at 02/07/2010 22:42:29
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote on 02/07/2010 02:56:58 AM:

> On Sun, Feb 07, 2010 at 06:34:51PM +1100, James Morris wrote:
> > Linus,
> > 
> > Please pull this bugfix.  I've verified that it fixes the null pointer 

> > deref.
> 
> NAK.  In that form it's simply wrong; we should never get there with
> NULL file->f_dentry->d_inode at all.  This is papering over the real
> bug; I'll post a saner fix shortly.
> 
> The real problem is BS hiding of ima_file_free() inside a hook, with
> condition that kinda-sorta happens to avoid bogus call most of the
> time.
> 
> ima_path_check() side is also of BUG_ON() variety (and isn't triggered).

hm, there was quite a bit of discussion that IMA should be called from
the security hooks (refer to http://lkml.org/lkml/2009/6/7/279),  so
commit 6c21a7f "LSM: imbed ima calls in the security hooks" moved them.

Mimi
