Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbXFPI0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbXFPI0X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 04:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbXFPI0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 04:26:12 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:46209
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939AbXFPI0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 04:26:10 -0400
Message-ID: <46739E89.1080003@hawkeye.stone.uk.eu.org>
Date: Sat, 16 Jun 2007 09:25:45 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk, hpa@zytor.com,
       alan <alan@clueserver.org>
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <4673182B.4090800@redhat.com>
In-Reply-To: <4673182B.4090800@redhat.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> The underlying internal implementation of something like this wouldn't
> be all that hard on many filesystems, but it's the interface that's the
> problem.  The ':' character is a perfectly legal filename character, so
> doing it that way would break things.

But to work without breaking userspace it would need to be a character
that would pass through any path checking routines, ie be a legal path
character.

> I think NetApp more or less got the interface right by putting a 
> .snapshot directory in each directory, with time-versioned
> subdirectories each containing snapshots of that directory's contents
> at those points in time.  It keeps the backups under the same
> hierarchy as the original files, to avoid permissions headaches,
> it's accessible over NFS without modifying the client at all,
> and it's hidden just enough to make it hard for users to do something
> stupid.

My personal implementation idea was to store lots of files for the form
file:revision_number (I'll keep using that until somebody sugests
something better) on the file system itself, with a hard link form the
latest version to file (this is probably not a major imporvement and
having the hard link coudl make it hard to implement deltas). This could
mean no changes to the file system itself (except maybe a flag to say
its versioned). The kernel would then do the translation to find the
correct file, and would only show the latest version to userapps not
requesting a specific version.

> If you want to do something like this (and it's generally not a bad
> idea), make sure you do it in a way that's not going to change the
> behavior seen by existing applications, and that is accessible to
> unmodified remote clients.  Hidden .snapshot directories are one way, a
> parallel /backup filesystem could be another, whatever.  If you break
> existing apps, I won't touch it with a ten foot pole.

The whole interface would be designed to give existing behavior as
default for two reasons: users are used to opening a file and getting
the latest version and not to break userspace. I personally wouldn't
touch this either if it broke userspace. The only userspace change would
be the addition of tools to manage the revisions etc. Userspace could
later upgrade to take advantage of the new functionality but I cannot
see the worth in breaking it.

For an example of a working implementation see:
http://www.o3one.org/filesystem.html

Jack
