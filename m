Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbYFCEKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbYFCEKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 00:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbYFCEKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 00:10:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:37506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbYFCEKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 00:10:07 -0400
Date: Mon, 2 Jun 2008 21:08:18 -0700
From: Greg KH <gregkh@suse.de>
To: Benjamin Thery <benjamin.thery@bull.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 09/10] netns: Enable tagging for net_class directories
	in sysfs
Message-ID: <20080603040818.GA18507@suse.de>
References: <20080602134438.224352910@theryb.frec.bull.fr> <20080602134439.782528644@theryb.frec.bull.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602134439.782528644@theryb.frec.bull.fr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 03:46:08PM +0200, Benjamin Thery wrote:
> net: Enable tagging for net_class directories in sysfs
> 
> The problem.  Network devices show up in sysfs and with the network
> namespace active multiple devices with the same name can show up in
> the same directory, ouch!
> 
> To avoid that problem and allow existing applications in network namespaces
> to see the same interface that is currently presented in sysfs, this
> patch enables the tagging directory support in sysfs.
> 
> By using the network namespace pointers as tags to separate out the
> the sysfs directory entries we ensure that we don't have conflicts
> in the directories and applications only see a limited set of
> the network devices.

I don't like it how the network subsystem is starting to leach into the
sysfs core here.  What happens when the next subsystem wants to do the
same thing?  And then the next one?  Will they all have to do this kind
of intrusive changes to sysfs?

Can't this be done only in the network subsystem?

thanks,

greg k-h
