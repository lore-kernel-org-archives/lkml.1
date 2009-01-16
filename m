Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbZAPPRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbZAPPRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbZAPPRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:17:06 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:52424 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbZAPPRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:17:04 -0500
Subject: Re: Btrfs Snapshot Removal And General Project Status
From: Chris Mason <chris.mason@oracle.com>
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <496DC1C6.7090307@turknet.net.tr>
References: <496DC1C6.7090307@turknet.net.tr>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 10:16:51 -0500
Message-Id: <1232119011.21473.24.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4970A4E7.0005:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 12:43 +0200, Tarkan Erimer wrote:
> Hi Chris,
> 

Sorry for the delay, I missed this one somehow.

> For the last few days, I was playing with btrfs. It looks really very 
> promising and fantastic! :-)

Glad to hear it worked.

> Thanks for everybody who involved with this amazing file system project! 
> ;-) Now, I play with snapshots. Creating snapshot is a breeze. 
> Recovering from snapshots work very well without any problems as far as 
> I tried. But; when I tried to remove the snapshot directories, I got an 
> error message that says : "cannot remove directory `snap1': Directory 
> not empty". But actually, it is empty. After that, I googled a bit and 
> found at "http://btrfs.wiki.kernel.org/index.php/Project_ideas" at 
> "Removal Snapshots" section, it states that it needs to be implement. 
> But, it's unclear which state this feature is now.
> 

That's right.  You did rm -rf dir, which is actually the slowest
possible way to remove the snapshot ;)  A much more optimized version is
possible, and already implemented as part of transaction commit.

But, the fast version is basically the same as unlinking a directory
that may or may not be in use.  We need to implement code to do that
properly wrt the VFS.

> It could be perfect to prepare a document that shows the current status 
> (completed, blah-blah % completed etc.) of the features,general status 
> of the project and maybe deadlines of feature implementions. Like : 
> "next release will have blah-blah features" etc.
> 

A very good point, I'm in the process of documenting this better.

> 
> BTW, is there any temporary way to remove these snapshot directories 
> before this "Remove Snapshot" feature implemented ? ;-)
> 

Unfortunately not, sorry.

-chris


