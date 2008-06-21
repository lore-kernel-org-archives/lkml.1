Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbYFUCEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbYFUCEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 22:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYFUCEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 22:04:40 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:32132 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbYFUCEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 22:04:39 -0400
Date: Fri, 20 Jun 2008 19:02:01 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>, Felix Fietkau <nbd@openwrt.org>,
       Al Viro <viro@ftp.linux.org.uk>, "H. Peter Anvin" <hpa@kernel.org>
Subject: Re: [RFC PATCHES] Re: Is configfs the right solution for
	configuration based fs?
Message-ID: <20080621020201.GH21416@mail.oracle.com>
Mail-Followup-To: Ben Nizette <bn@niasdigital.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>, Satyam Sharma <ssatyam@cse.iitk.ac.in>,
	Felix Fietkau <nbd@openwrt.org>, Al Viro <viro@ftp.linux.org.uk>,
	"H. Peter Anvin" <hpa@kernel.org>
References: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com> <1213002187.698.62.camel@johannes.berg> <1213056772.4089.42.camel@moss.renham> <20080619024804.GA29765@mail.oracle.com> <1213942750.2336.43.camel@moss.renham> <20080620065253.GA14238@ca-server1.us.oracle.com> <1213953776.2336.75.camel@moss.renham> <20080620213708.GC21416@mail.oracle.com> <1214010229.2336.88.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214010229.2336.88.camel@moss.renham>
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

On Sat, Jun 21, 2008 at 11:03:49AM +1000, Ben Nizette wrote:
> You know, I think you've about covered the boilerplate work.  Apart from
> that, well it took me a millisecond to work out what the point of
> config_{group,item}s was; I went in kinda expecting to see one struct
> for directories and one for attributes.  In fact I still not sure I can
> explain the need for config_items separate from config_groups.  Little
> help?  :-)

	Groups can create children, items cannot.  Think of kset vs
kobject, which is where it came from.
	Don't worry about directories vs files.  The view from the
client subsystem isn't about filesystem objects.  It's about a hierarchy
of items.  An item is a sigle entity.  It can have attributes.  A group
is an item that can have children.
	The fact that you access it via a filesystem is separate.  We
could have created a system call instead - the callbacks to your client
subsystem would have been the same.  Does that help?

Joel

-- 

Life's Little Instruction Book #511

	"Call your mother."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
