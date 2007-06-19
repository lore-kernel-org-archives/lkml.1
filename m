Return-Path: <linux-kernel-owner+w=401wt.eu-S1757798AbXFSXID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbXFSXID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbXFSXHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:07:51 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:36432 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbXFSXHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:07:49 -0400
Date: Tue, 19 Jun 2007 19:07:35 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: david@lang.hm, Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Chris Snook <csnook@redhat.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, alan <alan@clueserver.org>
Subject: Re: Versioning file system
Message-ID: <20070619230735.GN14788@delft.aura.cs.cmu.edu>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>, david@lang.hm,
	Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Chris Snook <csnook@redhat.com>,
	Jack Stone <jack@hawkeye.stone.uk.eu.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
	alan <alan@clueserver.org>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <4673182B.4090800@redhat.com> <46739E89.1080003@hawkeye.stone.uk.eu.org> <46781A5B.9090104@redhat.com> <20070619204317.GR10008@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706191505130.26701@asgard.lang.hm> <4678550D.6070705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4678550D.6070705@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jan Harkes <jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 03:13:33PM -0700, H. Peter Anvin wrote:
> david@lang.hm wrote:
> > 
> > the only trouble I ever had with the .snapshot approach is when tar or
> > find would decend down into the .snapshot when I didn't really intend
> > for it to do so.
> > 
> 
> Netapp optionally made .snapshot not show up in readdir, which solved
> that problem.
> 
> I have a bigger issue with it starting with only one dot, which is
> traditionally used for user configuration information.  I think
> ..snapshot would have been a better choice, and by extension leaving
> double-dot filenames as filesystem namespace (I know that contradicts
> POSIX, but the only namespace available in POSIX is /../ which is a
> global namespace.)

Still, anything that depends on increasing the length of file or path
names to refer to different versions will encounter problems for long
file names and deep paths because there is an upper limit on file and
path name lengths.

It may be possible to use namespaces where an application can change the
view it (and it's children) will have on the storage by switching to a
different namespace and tagging it with for instance a specific version
or date we're interested in. Not sure if we actually pass namespace
information down to the file systems yet though, last time I checked
they were only visible for the VFS.

Jan
