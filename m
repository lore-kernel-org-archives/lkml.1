Return-Path: <linux-kernel-owner+w=401wt.eu-S1760141AbYFBMdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141AbYFBMdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 08:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYFBMdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 08:33:05 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49231 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbYFBMdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:33:03 -0400
Date: Mon, 2 Jun 2008 06:32:46 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, jmorris@namei.org, sds@tycho.nsa.gov,
       eparis@redhat.com, casey@schaufler-ca.com, agruen@suse.de,
       jjohansen@suse.de, penguin-kernel@I-love.SAKURA.ne.jp,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/15] security: pass path to inode_create
Message-ID: <20080602123244.GC8562@parisc-linux.org>
References: <20080529134903.615127628@szeredi.hu> <20080529134958.655985182@szeredi.hu> <20080531083052.GH24135@infradead.org> <E1K2uXZ-0001eE-Oi@pomaz-ex.szeredi.hu> <20080602060144.GA11564@infradead.org> <E1K343a-0002dG-C9@pomaz-ex.szeredi.hu> <20080602112350.GB8562@parisc-linux.org> <E1K38JN-0003H0-J9@pomaz-ex.szeredi.hu> <E1K38aL-0003KY-Qq@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K38aL-0003KY-Qq@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 01:52:21PM +0200, Miklos Szeredi wrote:
> Found it:
> 
>    http://lkml.org/lkml/2008/4/9/98
> 
> I did not take part in that discussion and could not have been able to
> contribute anyway.  From a cursory read of the thread, the idea was
> good, but not entirely applicable to apparmor.  Or did I miss
> something?

Sorry, I thought you were on the CC for that.

The conversation was somewhat unclear, at least in part because I'd
misunderstood the apparmour deny vs allow logic.  It was also extremely
unhelpful when certain people decided to have a debate about path-name
based security.  So let me try again.

The point is to resolve pathnames into dev_t + inode in the
context where the rule is set up.  Then you can implement (say)
security_inode_permission() without needing to pass in a vfsmount -- all
you need are the inode->i_ino and inode->i_sb->s_dev to do a comparison.

Yes, if someone mounts /etc onto /etc2/ and has a rule to allow them to
access /etc/shadow, they will then be able to access /etc2/shadow as
well (which they weren't able to under previous apparmour).  But I can't
think of a way that permits Something Bad to happen (since the contents
of the file could have been accessed through /etc/shadow *anyway*).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
