Return-Path: <linux-kernel-owner+w=401wt.eu-S1759113AbXFTIp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113AbXFTIp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 04:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbXFTIpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 04:45:12 -0400
Received: from mail-relay-01.mailcluster.net ([85.249.135.242]:52841 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752717AbXFTIpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 04:45:10 -0400
Message-ID: <4678E90A.6000707@vlnb.net>
Date: Wed, 20 Jun 2007 12:44:58 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc5
X-Accept-Language: en-us, ru, en
MIME-Version: 1.0
To: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
Cc: Chris Mason <chris.mason@oracle.com>,
       =?ISO-8859-1?Q?P=E1draig_Brad?= =?ISO-8859-1?Q?y?= 
	<P@draigBrady.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
References: <20070612161029.GB28279@think.oraclecorp.com> <4676C2D6.8030708@vlnb.net> <46779DB1.7060807@draigBrady.com> <20070619120457.GD14108@think.oraclecorp.com> <20070619182813.GA21404@titan.lahn.de>
In-Reply-To: <20070619182813.GA21404@titan.lahn.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Matthias Hahn wrote:
>>>>I would also suggest one more feature: support for block level
>>>>de-duplication. I mean:
> 
> ...
> 
>>>>That would be very usable feature, which in most cases would allow to
>>>>shrink occupied disk space on 50-90%.
>>>
>>>Have you references for this number?
>>>In my experience one gets a lot of benefit from
>>>the much simpler process of "de-duplication" of files.
>>
>>Yes, I would expect simple hard links to be a better solution for this,
>>but the feature request is not that out of line.  I actually had plans
>>on implementing auto duplicate block reuse earlier in btrfs.
> 
> 
> One problem with hard-links for me is, they also share the meta-data,
> especially file permissions and owners.
> 
> Take a Subversion checkout for example: For each file "$A" Subversion
> saves a backup under ".svm/text-base/$A.svn-base" for file comparison
> and diff generation. The user controls the file permissions of "$A",
> Subversion protects its backup with 0444. You can't hard-link them,
> because than "svn diff" doesn't work anymore if your editor doesn't
> break the hard-link, or worse, your permissions can get wrong.
> 
> If previous versions Subversion also had an extra file for file
> attributes (mime-type, permissions, to-be-ignored, etc.) Since most
> files had no special attributes, each had a file only containing "END".
> Those you could hard-link by hand to save space.
> 
> If somebody want to research this further:
> 
> There is this nice little package called "perforate", which contains
> "finddup" to find duplicate files. Run it two times, once with "-i" to
> ignore permissions while comparing file contents
> 	finddup -i -d /
> and once without "-i" for "content and permissions must match"
> 	finddup -d /
> This will give you a hint on how many files you could hard-link or how
> many files share their content.

So, seems ever for file based de-duplication some support from the FS, 
including some kind of ability for different inodes point to the same 
data blocks to store the meta-data, would be needed anyway.

Vlad
