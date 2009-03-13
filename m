Return-Path: <linux-kernel-owner+w=401wt.eu-S1758451AbZCMR7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbZCMR7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759012AbZCMR6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:58:55 -0400
Received: from mail.fieldses.org ([141.211.133.115]:50488 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653AbZCMR6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:58:54 -0400
Date: Fri, 13 Mar 2009 13:58:48 -0400
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Igor Zhbanov <izh1979@gmail.com>,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, neilb@suse.de,
       Trond.Myklebust@netapp.com, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>
Subject: Re: VFS, NFS security bug? Should CAP_MKNOD and
	CAP_LINUX_IMMUTABLE be added to CAP_FS_MASK?
Message-ID: <20090313175848.GB27891@fieldses.org>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com> <20090311232356.GP13540@fieldses.org> <20090312161047.GA15209@us.ibm.com> <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 09:21:23AM +1300, Michael Kerrisk wrote:
> On Fri, Mar 13, 2009 at 5:10 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> > Quoting J. Bruce Fields (bfields@fieldses.org):
> >> On Wed, Mar 11, 2009 at 03:53:34PM +0300, Igor Zhbanov wrote:
> >> > Hello!
> >> >
> >> > It seems that CAP_MKNOD and CAP_LINUX_IMMUTABLE were forgotten to be
> >> > added to CAP_FS_MASK_B0 in linux-2.6.x and to CAP_FS_MASK in
> >> > linux-2.4.x. Both capabilities affects file system and can be
> >> > considered file system capabilities.
> >>
> >> Sounds right to me--I'd expect rootsquash to guarantee that new device
> >> nodes can't be created from the network.  Cc'ing random people from the
> >> git log for include/linux/capability.h in hopes they can help.
> >
> > Yeah it seems reasonable.  If it is, then does that mean that we
> > also need CAP_SYS_ADMIN (to write selinux labels) and CAP_SETFCAP
> > (to set file capabilities) as well?
> 
> If a change is made to CAP_FS_MASK, please do remember to CC
> mtk.manpages@gmail.com, and linux-api@.

OK, that's because the exact set of capabilities that is dropped on
setfsuid is documented in capabilities(7)?  (Anywhere else?)

--b.

> 
> Cheers,
> 
> Michael
> 
> 
> -- 
> Michael Kerrisk Linux man-pages maintainer;
> http://www.kernel.org/doc/man-pages/ Found a documentation bug?
> http://www.kernel.org/doc/man-pages/reporting_bugs.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
