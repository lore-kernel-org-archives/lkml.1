Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbZKQMhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbZKQMhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZKQMho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:37:44 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:19929 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbZKQMhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:37:43 -0500
Date: Tue, 17 Nov 2009 07:36:22 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Greg KH <gregkh@suse.de>
Cc: JiSheng Zhang <jszhang3@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, stable@kernel.org, jack@suse.cz
Subject: Re: [BUG]2.6.27.y some contents lost after writing to mmaped file
Message-ID: <20091117123622.GI27677@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Greg KH <gregkh@suse.de>, JiSheng Zhang <jszhang3@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org,
	jack@suse.cz
References: <2df346410911151938r1eb5c5e4q9930ac179d61ef01@mail.gmail.com>
 <20091117015655.GA8683@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117015655.GA8683@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B0298FA.00D8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 05:56:55PM -0800, Greg KH wrote:
> On Mon, Nov 16, 2009 at 11:38:57AM +0800, JiSheng Zhang wrote:
> > Hi,
> > 
> > I triggered a failure in an fs test with fsx-linux from ltp. It seems that
> > fsx-linux failed at mmap->write sequence.
> > 
> > Tested kernel is 2.6.27.12 and 2.6.27.39
> 
> Does this work on any kernel you have tested?  Or is it a regression?
> 
> > Tested file system: ext3, tmpfs.
> > IMHO, it impacts all file systems.
> > 
> > Some fsx-linux log is:
> > 
> > READ BAD DATA: offset = 0x2771b, size = 0xa28e
> > OFFSET  GOOD    BAD     RANGE
> > 0x287e0 0x35c9  0x15a9     0x80
> > operation# (mod 256) for the bad datamay be 21
> > ...
> > 7828: 1257514978.306753 READ     0x23dba thru 0x25699 (0x18e0 bytes)
> > 7829: 1257514978.306899 MAPWRITE 0x27eeb thru 0x2a516 (0x262c bytes)
> >  ******WWWW
> > 7830: 1257514978.307504 READ     0x2771b thru 0x319a8 (0xa28e bytes)
> >  ***RRRR***
> > Correct content saved for comparison
> > ...
> 
> Are you sure that the LTP is correct?  It wouldn't be the first time it
> wasn't...

I'm afraid fsx usually finds bugs.  I thought Jan Kara recently fixed
something here in ext3, does 2.6.32-rc work?

-chris

