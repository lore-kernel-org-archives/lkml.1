Return-Path: <linux-kernel-owner+w=401wt.eu-S1161772AbXDYAU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161772AbXDYAU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 20:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030829AbXDYAU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 20:20:57 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:31101 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030419AbXDYAUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 20:20:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:references;
        b=JpleXVAeME2UOXMRKTksExiv8ULAy2XndmpNAGX3nfD0Hdsp5vKbFlJ1hfveh309nODSkWhrfahn2tqBh/q5AK88MAyhfDw3q6AVwZ4g+GVXwUP9WDv42qJUf6l3gTgRcCb09i4pX3vVNqccWrNOcRN8Zqca7uDOMFide4TV4Ug=
Message-ID: <2e4afe1e0704241720q3eb54e24gcd10b2026759333@mail.gmail.com>
Date: Wed, 25 Apr 2007 05:50:55 +0530
From: "Karuna sagar K" <karunasagark@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, "Kalpak Shah" <kalpak@linsyssoft.com>,
       "Amit Gud" <gud@ksu.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: ChunkFS - measuring cross-chunk references
In-Reply-To: <2e4afe1e0704241717l6e6ec72by898727b5973c221@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_35177_21685789.1177460455060"
References: <2e4afe1e0704221335y6d4c84d8id65e71826ce60acb@mail.gmail.com>
	 <462B8D0C.7020509@ksu.edu>
	 <2e4afe1e0704230019h3853bc82uae6c9b5cdc325ab9@mail.gmail.com>
	 <1177320876.23226.7.camel@garfield>
	 <20070423205333.GZ5967@schatzie.adilger.int>
	 <20070424001306.GB1663@thunk.org>
	 <2e4afe1e0704241717l6e6ec72by898727b5973c221@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_35177_21685789.1177460455060
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 4/24/07, Theodore Tso <tytso@mit.edu> wrote:
> On Mon, Apr 23, 2007 at 02:53:33PM -0600, Andreas Dilger wrote:
.........
> It would also be good to distinguish between directories referencing
> files in another chunk, and directories referencing subdirectories in
> another chunk (which would be simpler to handle, given the topological
> restrictions on directories, as compared to files and hard links).
>

Modified the tool to distinguish between
1. cross references between directories and files
2. cross references between directories and sub directories
3. cross references within a file (due to huge file size)

Below is the result from / partition of ext3 file system:

Number of files = 221794
Number of directories = 24457
Total size = 8193116 KB
Total data stored = 7187392 KB
Size of block groups = 131072 KB
Number of inodes per block group = 16288
No. of cross references between directories and sub-directories = 7791
No. of cross references between directories and file = 657
Total no. of cross references = 62018 (dir ref = 8448, file ref = 53570)

Thanks for the suggestions.

> There may also be special things we will need to do to handle
> scenarios such as BackupPC, where if it looks like a directory
> contains a huge number of hard links to a particular chunk, we'll need
> to make sure that directory is either created in the right chunk
> (possibly with hints from the application) or migrated to the right
> chunk (but this might cause the inode number of the directory to
> change --- maybe we allow this as long as the directory has never been
> stat'ed, so that the inode number has never been observed).
>
> The other thing which we should consider is that chunkfs really
> requires a 64-bit inode number space, which means either we only allow
> it on 64-bit systems, or we need to consider a migration so that even
> on 32-bit platforms, stat() functions like stat64(), insofar that it
> uses a stat structure which returns a 64-bit ino_t.
>
>                                                - Ted
>


Thanks,
Karuna

------=_Part_35177_21685789.1177460455060
Content-Type: application/x-bzip2; name=cref.tar.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f0x13zzw
Content-Disposition: attachment; filename="cref.tar.bz2"

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
jyxB/4u5IpwoSAAlWDAA
------=_Part_35177_21685789.1177460455060--
