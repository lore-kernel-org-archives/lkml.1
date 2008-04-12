Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbYDLTQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbYDLTQQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 15:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbYDLTQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 15:16:03 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52583 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbYDLTQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 15:16:00 -0400
Subject: Re: Multiple instances of devpts
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, sukadev@us.ibm.com,
       Andrew Morton <akpm@osdl.org>, serue@us.ibm.com, matthltc@us.ibm.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <48010583.3020403@zytor.com>
References: <20080412172933.GA19295@us.ibm.com>
	 <20080412183514.GO9785@ZenIV.linux.org.uk>  <48010583.3020403@zytor.com>
Content-Type: text/plain
Date: Sat, 12 Apr 2008 12:15:57 -0700
Message-Id: <1208027757.28187.25.camel@x61.ebiederm.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on mgr1.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-04-12 at 11:54 -0700, H. Peter Anvin wrote:
> Al Viro wrote:
> > 
> > Why not simply allow independent instances of devpts and be done with that?
> 
> In particular:
> 
> /dev/ptmx can be a symlink ptmx -> pts/ptmx, and we add a ptmx instance 
> inside the devpts filesystem.  Each devpts filesystem is responsible for 
> its own pool of ptys, with own numbering, etc.
> 
> This does mean that entries in /dev/pts are more than just plain device 
> nodes, which they are now (you can cp -a a device node from /dev/pts 
> into another filesystem and it will still "just work"), but I doubt this 
> actually matters to anyone.  If anyone cares, now I guess would be a 
> good time to speak up.

Agreed.   That is another legitimate path.  And if all you care about is
isolation and not dealing with the general class of problems with the
global device number to device mapping that is sane.  I know we have
several other virtual devices that we tend to care about but ptys are
the real world pain point.

Further I don't see any conflict with the generalizing devpts in this
manner (so you only see a subset of the ptys) and then later adding a
namespace that deals with the whole device number to device mapping.

Eric




