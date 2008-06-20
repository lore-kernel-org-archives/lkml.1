Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbYFTGTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbYFTGTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 02:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYFTGS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 02:18:59 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:52679
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbYFTGS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 02:18:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqoAALPoWkh8qNQu/2dsb2JhbAAIr04
X-IronPort-AV: E=Sophos;i="4.27,677,1204470000"; 
   d="scan'208";a="279445297"
Subject: Re: [RFC PATCHES] Re: Is configfs the right solution for
	configuration based fs?
From: Ben Nizette <bn@niasdigital.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>, Felix Fietkau <nbd@openwrt.org>,
       Al Viro <viro@ftp.linux.org.uk>, "H. Peter Anvin" <hpa@kernel.org>
In-Reply-To: <20080619024804.GA29765@mail.oracle.com>
References: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com>
	 <1213002187.698.62.camel@johannes.berg>
	 <1213056772.4089.42.camel@moss.renham>
	 <20080619024804.GA29765@mail.oracle.com>
Content-Type: text/plain
Organization: Nias Digital
Date: Fri, 20 Jun 2008 16:19:10 +1000
Message-Id: <1213942750.2336.43.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-06-18 at 19:48 -0700, Joel Becker wrote:

> 	Ask, and ye shall receive.  I've actually been meaning to look
> at this for a while.  Please check out the branch configfs-attr-macros
> at my git tree.  Actually, here is the configfs.h with macros, and
> configfs_example_macros.c using them.  Let me know if this fits the
> bill.
> 
> [config-attr-macros:include/linux/configfs.h]
> http://oss.oracle.com/git/jlbec/linux-2.6.git/?p=jlbec/linux-2.6.git;a=blob;f=include/linux/configfs.h;h=8be4507ab98f49f43c5212cbafe62178df9a517b;hb=c085c60b185d7431935397e43a868325d8f1da6c
> 
> [config-attr-macros:Documentation/filesystems/configfs/configfs_example_macros.c]
> http://oss.oracle.com/git/jlbec/linux-2.6.git/?p=jlbec/linux-2.6.git;a=blob;f=Documentation/filesystems/configfs/configfs_example_macros.c;h=c2ece748abdf30a7d67dd9ea25c5e6ac93fbc005;hb=c085c60b185d7431935397e43a868325d8f1da6c
> 
> 	Compare and contrast with the original configfs_example.c (now
> configfs_example_explicit.c on that branch).  The diff is available
> here:
> http://oss.oracle.com/git/jlbec/linux-2.6.git/?p=jlbec/linux-2.6.git;a=commitdiff;h=c085c60b185d7431935397e43a868325d8f1da6c
> 

Looks great, thx :-).  I'll convert some of my stuff over to this
interface and see how it flies in the real world.

> > And the trival problem that, ISTR, failing the make_group method always
> > reports -ENOMEM to userspace, no matter what the actual problem was.  I
> > think I had a patch around to pass the error code from make_group back
> > up through to userspace, I wonder what happened to that...
> 
> 	I've also attacked this one.  The change is in the
> make-item-errors branch.  It's already scheduled for linux-next.  Diff
> available here:
> http://oss.oracle.com/git/jlbec/linux-2.6.git/?p=jlbec/linux-2.6.git;a=commitdiff;h=34fbb494fecfd82bcbf9ed698ef305500228a84c
> 

ISTR when I did this I kept the old semantics and used ERR_PTR and
friends if things went pear-shaped.  Given the small number of in-tree
users needing to be moved over, a more intrusive change for the sake of
a cleaner API like you've done is probably a good thing anyway :-)

Thanks again,
	--Ben.


