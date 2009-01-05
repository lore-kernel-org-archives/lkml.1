Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbZAEDXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbZAEDXf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 22:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZAEDXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 22:23:00 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43043
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbZAEDW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 22:22:57 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: document ext3 requirements
Date: Sun, 4 Jan 2009 21:22:35 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Theodore Tso <tytso@mit.edu>, Duane Griffin <duaneg@dghda.com>,
       Valdis.Kletnieks@vt.edu,
       Martin =?utf-8?q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com> <20090104184040.GC17558@mit.edu> <Pine.LNX.4.64.0901042015230.31141@anakin>
In-Reply-To: <Pine.LNX.4.64.0901042015230.31141@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901042122.35828.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 January 2009 13:21:06 Geert Uytterhoeven wrote:
> I think most people get shocked when they discover that mounting something
> read-only may actualy write to the media. This is a bit unexpected (hey, if
> I mount `read-only', I expect that no writes will happen), as it behaved
> differently before the introduction of journalling.

Is this an unreasonable use case:

  kill -STOP $(pidof qemu)
  mount -o loop,ro hdb.img blah
  cp blah/thingy thingy
  umount blah
  kill -CONT $(pidof qemu)

Currently, if your loopback mount is -t ext3 it'll write to the block device, 
and if your mount is -t ext2 it'll refuse to work on an unclean ext3 
filesystem, even if it's read only.  (But it _will_ work on an unclean ext2 
filesystem.)

My theory when I first found out about this was "the filesystem developers 
hate me personally".

Rob
