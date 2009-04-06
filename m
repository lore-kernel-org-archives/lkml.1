Return-Path: <linux-kernel-owner+w=401wt.eu-S1761317AbZDFWB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761317AbZDFWB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759836AbZDFVzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:55:19 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:40647 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759725AbZDFVzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:55:17 -0400
X-Greylist: delayed 1365 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Apr 2009 17:55:17 EDT
Message-ID: <49DA74E9.9050702@tlinx.org>
Date: Mon, 06 Apr 2009 14:32:25 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: supporting laptops fs-semantic changes (was Re: Ext4 and the "30
 second window of death")
References: <200903291224.21380.info@gnebu.es> <200903311452.05210.info@gnebu.es> <20090331134547.GJ13356@mit.edu> <200904010002.47077.info@gnebu.es> <49D2A5AB.1090704@ursus.ath.cx> <20090401015010.GB4529@mit.edu> <20090401052050.GA20456@sucs.org> <20090401151219.GA12285@srcf.ucam.org> <20090401173521.GA15423@mit.edu> <20090401174336.GA14726@srcf.ucam.org>
In-Reply-To: <20090401174336.GA14726@srcf.ucam.org>
X-Stationery: 0.4.8.14
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
>> The other subtlety comes if we add fsync() suppression to laptop mode
-----
    Perhaps this has already been suggested, but rather than
adding all these semantics to the core file-system / kernel routines,
wouldn't it be preferable to allow some 'layering' of a pseudo,
memory-based file-system, OVER some 'real' file system (OR), definable
set of files (under a subdir...or same device...or whatever).

The semantics of when the virtual-fs would sync to the physical-fs/files
controlled via mount options.  Physical disk writes would be controlled by
selectively ignoring or honoring various "sync" events (time expired,
sync, fsync).

This could allow file-systems with different 'needs' (DB, or otherwise)
to be treated differently. 

The advantage of another layer, is you could define _how much_ buffering
you wanted to allocate to a filesystem (or file-set).  Maybe it's tolerable
losing a audio-recording of a talk, so large buff + don't sync 'cept when
full is fine.  Sensitive filesystems(or sets) (i.e. db's), could be set
with buffers to hold largest 'single-writes', but sync/fsyncs are what
they are.

An optimization could provide for read/writes through the user-mem 
controlled
buffered 'fs', to do direct I/O rather than into normal file-buffs where
possible, since presumably all accesses to a file would go through the
layer or not.

Wouldn't require application changing, and wouldn't require changing
well defined, lower-level kernel-filesystem operations.

Just a thought.
Linda

