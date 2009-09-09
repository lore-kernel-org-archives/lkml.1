Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbZIIHsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbZIIHsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 03:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbZIIHsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 03:48:13 -0400
Received: from smtp.nokia.com ([192.100.122.230]:27978 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbZIIHsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 03:48:12 -0400
Subject: Re: [PATCH take 3][RFC] fat: Save FAT root directory timestamps to
	volume label
From: =?ISO-8859-1?Q?J=F6rg?= Schummer <ext-jorg.2.schummer@nokia.com>
To: ext Jamie Lokier <jamie@shareable.org>
Cc: "hirofumi@mail.parknet.co.jp" <hirofumi@mail.parknet.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20090908153949.GD5579@shareable.org>
References: <1252420131.5782.2.camel@jorg-desktop>
	 <1252420448-7282-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	 <20090908153949.GD5579@shareable.org>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 09 Sep 2009 10:47:47 +0300
Message-Id: <1252482467.5782.12.camel@jorg-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Sep 2009 07:47:55.0062 (UTC) FILETIME=[D760FD60:01CA3121]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 17:39 +0200, ext Jamie Lokier wrote:
> Jorg Schummer wrote:
> > Standard FAT implementations cannot store any of the FAT root directory's
> > timestamps. This commit adds the mount option 'rootts', which allows saving
> > the FAT root directory timestamps as the timestamps of the FAT volume label
> > directory entry. At least Mac OS X is known to support the same mechanism
> > and interoperate with this commit.
> > 
> > When mounting, the following values can be specified for the 'rootts' mount
> > option:
> > 
> >   "rootts=ignore"   ignores root directory timestamps. All timestamps are
> >                     reset to 0 (1/1/1970). This has been the FAT behaviour
> >                     prior to this patch.
> > 
> >   "rootts=preserve" tries to load and save the root directory's timestamps
> >                     if a volume label entry exists. The mtime and atime are
> >                     corrected based on root directory entries' ctime. This
> >                     is the default.
> > 
> >   "rootts=save"     tries to load and save the root directory's timestamps.
> >                     The mtime and atime are corrected based on root
> >                     directory entries' ctime. If the root directory was
> >                     accessed but no volume label entry exists, the label
> >                     "NO NAME" is created.
> 
> Does Mac OS X do the same "NO NAME" thing?

AFAIK: No. It only supports the general mechanism of storing / loading
the root dir timestamps to / from the volume label entry.

But feel free to re-check that one.

Jörg


