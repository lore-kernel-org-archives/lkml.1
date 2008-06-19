Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbYFSC7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbYFSC7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 22:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYFSC73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 22:59:29 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36920 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbYFSC72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 22:59:28 -0400
Date: Wed, 18 Jun 2008 19:48:05 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>, Felix Fietkau <nbd@openwrt.org>,
       Al Viro <viro@ftp.linux.org.uk>, "H. Peter Anvin" <hpa@kernel.org>
Subject: [RFC PATCHES] Re: Is configfs the right solution for configuration
	based fs?
Message-ID: <20080619024804.GA29765@mail.oracle.com>
Mail-Followup-To: Ben Nizette <bn@niasdigital.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>, Satyam Sharma <ssatyam@cse.iitk.ac.in>,
	Felix Fietkau <nbd@openwrt.org>, Al Viro <viro@ftp.linux.org.uk>,
	"H. Peter Anvin" <hpa@kernel.org>
References: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com> <1213002187.698.62.camel@johannes.berg> <1213056772.4089.42.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213056772.4089.42.camel@moss.renham>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 10:12:52AM +1000, Ben Nizette wrote:
>

	Thanks, Ben, for providing constructive comments.  I know I
replied later with some of the known issues.  Here are some tentative
solutions! (Why now, you ask?  I just finished up something and had a
free moment)

> What's the first one, sysfs..?  ioctl (eww..)?  I do think they solve
> different problems, both have their place.  IMHO sysfs is forced to do
> configuration in some situations where it just doesn't fit.  Prolly 'coz
> sysfs have the easy __DEVICE_ATTR kinda macros where as configfs takes
> more effort to get flying.
<snip>
> That and a bit of wider use would probably see configfs growing helper
> macros like those which make sysfs attributes a piece of cake to
> implement.

	Ask, and ye shall receive.  I've actually been meaning to look
at this for a while.  Please check out the branch configfs-attr-macros
at my git tree.  Actually, here is the configfs.h with macros, and
configfs_example_macros.c using them.  Let me know if this fits the
bill.

[config-attr-macros:include/linux/configfs.h]
http://oss.oracle.com/git/jlbec/linux-2.6.git/?p=jlbec/linux-2.6.git;a=blob;f=include/linux/configfs.h;h=8be4507ab98f49f43c5212cbafe62178df9a517b;hb=c085c60b185d7431935397e43a868325d8f1da6c

[config-attr-macros:Documentation/filesystems/configfs/configfs_example_macros.c]
http://oss.oracle.com/git/jlbec/linux-2.6.git/?p=jlbec/linux-2.6.git;a=blob;f=Documentation/filesystems/configfs/configfs_example_macros.c;h=c2ece748abdf30a7d67dd9ea25c5e6ac93fbc005;hb=c085c60b185d7431935397e43a868325d8f1da6c

	Compare and contrast with the original configfs_example.c (now
configfs_example_explicit.c on that branch).  The diff is available
here:
http://oss.oracle.com/git/jlbec/linux-2.6.git/?p=jlbec/linux-2.6.git;a=commitdiff;h=c085c60b185d7431935397e43a868325d8f1da6c

> And the trival problem that, ISTR, failing the make_group method always
> reports -ENOMEM to userspace, no matter what the actual problem was.  I
> think I had a patch around to pass the error code from make_group back
> up through to userspace, I wonder what happened to that...

	I've also attacked this one.  The change is in the
make-item-errors branch.  It's already scheduled for linux-next.  Diff
available here:
http://oss.oracle.com/git/jlbec/linux-2.6.git/?p=jlbec/linux-2.6.git;a=commitdiff;h=34fbb494fecfd82bcbf9ed698ef305500228a84c

Joel

-- 

Life's Little Instruction Book #226

	"When someone hugs you, let them be the first to let go."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
