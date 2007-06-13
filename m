Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbXFMQYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbXFMQYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 12:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758569AbXFMQYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 12:24:34 -0400
Received: from alpha.lp.pl ([194.1.144.4]:50571 "EHLO alpha.polcom.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758484AbXFMQYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 12:24:33 -0400
Date: Wed, 13 Jun 2007 18:25:08 +0200 (CEST)
From: Grzegorz Kulewski <kangur@polcom.net>
To: Chris Mason <chris.mason@oracle.com>
Cc: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
In-Reply-To: <20070613145442.GC28279@think.oraclecorp.com>
Message-ID: <Pine.LNX.4.63.0706131818120.9760@alpha.polcom.net>
References: <20070612161029.GB28279@think.oraclecorp.com>
 <18031.26764.586958.632146@stoffel.org> <20070613103522.GW28279@think.oraclecorp.com>
 <18031.63640.103936.137412@stoffel.org> <20070613145442.GC28279@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2007, Chris Mason wrote:
> But, I'm not planning on adding a way to say user X in subvolume Y has
> quota Z.  I'll just be: this subvolume can't get bigger than a given
> size.  (at least for version 1.0).

I am affraid that this one is a major stopper for any production usage. 
Think about OpenVZ (or similar) VPSes. Of course having each VPS in own 
subvolume on the same device and being able to limit each subvolume is 
more than cool but on the other hand admin in VPS really needs to be able 
to set normal quotas for his users.

Other than that your project looks really good and interesting.

I also wonder if it is (would be) possible to set per-tree quotas like 
this:

/a     - 20GB
/a/b   - 10GB
/a/b/c -  2GB
/a/d   -  5GB
/e     - 30GB

meaning that whole subtree under /a is limited to 20GB, whole tree under 
/a/b is limited to both 20GB of /a and also by 10GB of /a/b, tree under 
/a/b/c is limited by 20GB of /a, 10GB of /a/b and 2GB of /a/b/c and 
so on? Or only /a and /e could be limited?


Thanks,

Grzegorz Kulewski
