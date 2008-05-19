Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbYESAuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbYESAuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 20:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYESAu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 20:50:29 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61927 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966AbYESAu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 20:50:28 -0400
Date: Sun, 18 May 2008 20:49:55 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Stefano Fedrigo <aleph@develer.com>
Cc: Bernie Innocenti <bernie@codewiz.org>, lkml <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, ext3-users@redhat.com,
       ext2-devel@lists.sourceforge.net
Subject: Re: ext3_dx_add_entry: Directory index full!
Message-ID: <20080519004955.GD8335@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Stefano Fedrigo <aleph@develer.com>,
	Bernie Innocenti <bernie@codewiz.org>,
	lkml <linux-kernel@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>, ext3-users@redhat.com,
	ext2-devel@lists.sourceforge.net
References: <48304CE2.1090808@codewiz.org> <20080518162429.GE31413@mit.edu> <3A94CB82-6BF7-42DD-96DE-5B6018600077@develer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3A94CB82-6BF7-42DD-96DE-5B6018600077@develer.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 01:01:57AM +0200, Stefano Fedrigo wrote:
>
> So, if I understand correctly, with a 1024 bytes blocksize, dir_index, and 
> inode size of 128 byte, the maximum number of files in a directory is 
> 123008.  With 4k blocks this limit rises to 8,258,048 files?

It depends on the length of the directory entries, and how full the
various directory blocks end up getting (which is a function of the
directory names used and the per-filesystem hash seed).  But in
general, the maximum limit goes up as the cube of the blocksize.  So a
4k filesystem can store roughly 64 times as many files ; a filesystem
using 16k blocks (say, on a Power or IA64 architecture) will be able
to store roughly 4,096 as many files in a single directory.  (So
around 819 million files in a single directory, using the original
maildir example).

Seriously, though, past a certain point, if you really want to store
that many small datums, you should really consider a database....

     	  		    	   	  - Ted
