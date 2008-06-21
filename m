Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbYFUIDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbYFUIDt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 04:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYFUID3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 04:03:29 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:45373
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094AbYFUID1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 04:03:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugAABtSXEh8qNQu/2dsb2JhbAAIrww
X-IronPort-AV: E=Sophos;i="4.27,683,1204470000"; 
   d="scan'208";a="345611450"
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
In-Reply-To: <20080621020201.GH21416@mail.oracle.com>
References: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com>
	 <1213002187.698.62.camel@johannes.berg>
	 <1213056772.4089.42.camel@moss.renham>
	 <20080619024804.GA29765@mail.oracle.com>
	 <1213942750.2336.43.camel@moss.renham>
	 <20080620065253.GA14238@ca-server1.us.oracle.com>
	 <1213953776.2336.75.camel@moss.renham>
	 <20080620213708.GC21416@mail.oracle.com>
	 <1214010229.2336.88.camel@moss.renham>
	 <20080621020201.GH21416@mail.oracle.com>
Content-Type: text/plain
Organization: Nias Digital
Date: Sat, 21 Jun 2008 18:03:42 +1000
Message-Id: <1214035422.2336.121.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-06-20 at 19:02 -0700, Joel Becker wrote:
> On Sat, Jun 21, 2008 at 11:03:49AM +1000, Ben Nizette wrote:
> > You know, I think you've about covered the boilerplate work.  Apart from
> > that, well it took me a millisecond to work out what the point of
> > config_{group,item}s was; I went in kinda expecting to see one struct
> > for directories and one for attributes.  In fact I still not sure I can
> > explain the need for config_items separate from config_groups.  Little
> > help?  :-)
> 
> 	Groups can create children, items cannot.  Think of kset vs
> kobject, which is where it came from.
> 	Don't worry about directories vs files.  The view from the
> client subsystem isn't about filesystem objects.  It's about a hierarchy
> of items.  An item is a sigle entity.  It can have attributes.  A group
> is an item that can have children.

I guess I don't quite see why all items don't have the ability to have
children.  I mean, a config_item has a config_item_type which contains
the group_ops anyway; I don't quite see why the children, default_groups
and subsys members from config_group don't live inside config_item and
be done with it.

In the kobject/kset case the separation makes sense as kobjects are
embedded in things all over the kernel controlling things like ref
counting, device model glue, hotplug info as well as the sysfs
representation.  The config_item doesn't have any responsibilities
outside of the configfs representation (does it?) so the analogy isn't
100%.  Though of course the item/group split makes sense if there are
grander plans for the config_item in the future.

> 	The fact that you access it via a filesystem is separate.  We
> could have created a system call instead - the callbacks to your client
> subsystem would have been the same.

Right

>   Does that help?

Indeed, thx.

	--Ben.

> 
> Joel
> 
