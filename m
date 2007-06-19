Return-Path: <linux-kernel-owner+w=401wt.eu-S1764602AbXFSS66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764602AbXFSS66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764381AbXFSS6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:58:47 -0400
Received: from ip-svs-1.Informatik.Uni-Oldenburg.DE ([134.106.12.126]:33619
	"EHLO schlidder.svs.informatik.uni-oldenburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764344AbXFSS6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:58:45 -0400
X-Greylist: delayed 1827 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2007 14:58:44 EDT
Date: Tue, 19 Jun 2007 20:28:13 +0200
From: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
To: Chris Mason <chris.mason@oracle.com>
Cc: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
       Vladislav Bolkhovitin <vst@vlnb.net>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
Message-ID: <20070619182813.GA21404@titan.lahn.de>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	=?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
	Vladislav Bolkhovitin <vst@vlnb.net>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20070612161029.GB28279@think.oraclecorp.com> <4676C2D6.8030708@vlnb.net> <46779DB1.7060807@draigBrady.com> <20070619120457.GD14108@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070619120457.GD14108@think.oraclecorp.com>
Organization: UUCP-Freunde Lahn e.V.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Tue, Jun 19, 2007 at 08:04:57AM -0400, Chris Mason wrote:
> On Tue, Jun 19, 2007 at 10:11:13AM +0100, Pádraig Brady wrote:
> > Vladislav Bolkhovitin wrote:
> > > 
> > > I would also suggest one more feature: support for block level
> > > de-duplication. I mean:
...
> > > That would be very usable feature, which in most cases would allow to
> > > shrink occupied disk space on 50-90%.
> > 
> > Have you references for this number?
> > In my experience one gets a lot of benefit from
> > the much simpler process of "de-duplication" of files.
> 
> Yes, I would expect simple hard links to be a better solution for this,
> but the feature request is not that out of line.  I actually had plans
> on implementing auto duplicate block reuse earlier in btrfs.

One problem with hard-links for me is, they also share the meta-data,
especially file permissions and owners.

Take a Subversion checkout for example: For each file "$A" Subversion
saves a backup under ".svm/text-base/$A.svn-base" for file comparison
and diff generation. The user controls the file permissions of "$A",
Subversion protects its backup with 0444. You can't hard-link them,
because than "svn diff" doesn't work anymore if your editor doesn't
break the hard-link, or worse, your permissions can get wrong.

If previous versions Subversion also had an extra file for file
attributes (mime-type, permissions, to-be-ignored, etc.) Since most
files had no special attributes, each had a file only containing "END".
Those you could hard-link by hand to save space.

If somebody want to research this further:

There is this nice little package called "perforate", which contains
"finddup" to find duplicate files. Run it two times, once with "-i" to
ignore permissions while comparing file contents
	finddup -i -d /
and once without "-i" for "content and permissions must match"
	finddup -d /
This will give you a hint on how many files you could hard-link or how
many files share their content.

BYtE
Philipp
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@titan.lahn.de
