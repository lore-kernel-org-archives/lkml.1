Return-Path: <linux-kernel-owner+w=401wt.eu-S1751147AbXBZJGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147AbXBZJGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 04:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbXBZJGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 04:06:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbXBZJF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 04:05:59 -0500
From: Neil Brown <neilb@suse.de>
To: "Patrick Ale" <patrick.ale@gmail.com>
Date: Mon, 26 Feb 2007 20:05:02 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17890.41662.486226.273826@notabene.brown>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PROBMEL] MD doesn't like /dev/disk/by-id
In-Reply-To: message from Patrick Ale on Monday February 26
References: <8d158e1f0702260055m5d3cf93cqce58e366d677c090@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday February 26, patrick.ale@gmail.com wrote:
> Hi,
> 
> I posted this a while ago aswell :)
> 
> MD can't start anymore when /etc/mdadm.conf uses /dev/disk/by-id/* ,
> it bluntly tells you there are no suiteable drives.

What else does it say if you run with "-v"

> 
> Since libata tends to mangle my drive order by every reboot since I
> use 3 controllers and the drivers dont generate uevents always in the
> same sequence the only thing left to use are UUIDs.

No.  You can use the uuid in the md metadata.  Don't mention devices
in mdadm.conf at all.  Just

  ARRAY /dev/md1 UUID=xxxxx:xxxxx:Xxxxxx:xxxxx

and it should find the right devices and assemble them without
problems.


> 
> Now, this isnt a problem but is this the *only* way the mdadm devices
> will startable now and is this the only way the MD module will
> support?

The only supported way to assemble arrays when md is a module is to
use mdadm.  Mdadm has several ways to identify an array.  Check the
man page.

> 
> And if yes, maybe this should be communicated somewhere, cause
> something tells me I am not the only one who had this problem or will
> have :)
> 

Suggestions for specific improvements to the md and mdadm documentation
are always welcome.  Read mdadm.8 again and then tell me what you
wanted it to tell you that wasn't clear.

Thanks,
NeilBrown
