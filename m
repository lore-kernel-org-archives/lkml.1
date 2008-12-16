Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbYLPBje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbYLPBje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 20:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYLPBj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 20:39:26 -0500
Received: from rcsinet14.oracle.com ([148.87.113.126]:46491 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbYLPBjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 20:39:25 -0500
Subject: Re: Btrfs trees for linux-next
From: Chris Mason <chris.mason@oracle.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andreas Dilger <adilger@sun.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <ac3eb2510812151455h27b790av9579b670edbca7ab@mail.gmail.com>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	 <1228962896.21376.11.camel@think.oraclecorp.com>
	 <20081211141436.030c2d65.sfr@canb.auug.org.au>
	 <20081210200604.8e190b0d.akpm@linux-foundation.org>
	 <1229006596.22236.46.camel@think.oraclecorp.com>
	 <20081215210323.GB5000@webber.adilger.int>
	 <ac3eb2510812151455h27b790av9579b670edbca7ab@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 20:37:27 -0500
Message-Id: <1229391447.27573.6.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4947065B.0067:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-15 at 23:55 +0100, Kay Sievers wrote:
> On Mon, Dec 15, 2008 at 22:03, Andreas Dilger <adilger@sun.com> wrote:
> > On Dec 11, 2008  09:43 -0500, Chris Mason wrote:
> >> The multi-device code uses a very simple brute force scan from userland
> >> to populate the list of devices that belong to a given FS.  Kay Sievers
> >> has some ideas on hotplug magic to make this less dumb.  (The scan isn't
> >> required for single device filesystems).
> >
> > This should use libblkid to do the scanning of the devices, and it can
> > cache the results for efficiency.  Best would be to have the same LABEL+UUID
> > for all devices in the same filesystem, and then once any of these devices
> > are found the mount.btrfs code can query the rest of the devices to find
> > the remaining parts of the filesystem.
> 
> Which is another way to do something you should not do that way in the
> first place, just with a library instead of your own code.
> 

Well, its the same library everyone else is using to do things they
shouldn't be doing ;)

I'm very interested in your new  scheme for device discovery.  It seems
like the best and most reasonable way to go forward.

But, tossing things into libblkid also makes sense.  It isn't much work,
and it allows btrfs to fit in with the established norms while we
experiment with new and better ways to hook it all together.

-chris


