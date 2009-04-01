Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbZDAFVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbZDAFVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 01:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbZDAFVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 01:21:07 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:59182 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZDAFVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 01:21:06 -0400
Date: Wed, 1 Apr 2009 06:20:50 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Theodore Tso <tytso@mit.edu>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090401052050.GA20456@sucs.org>
References: <200903291224.21380.info@gnebu.es> <200903311452.05210.info@gnebu.es> <20090331134547.GJ13356@mit.edu> <200904010002.47077.info@gnebu.es> <49D2A5AB.1090704@ursus.ath.cx> <20090401015010.GB4529@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401015010.GB4529@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 09:50:10PM -0400, Theodore Tso wrote:
> 
> But still, you're right.  In some cases, you really want "fsync()" to
> mean "fsync()".  I'm not sure how often such applications _should_ be

Hmm. This is starting to sound a lot like the OSX fsync (
http://developer.apple.com/documentation/Darwin/Reference/Manpages/man2/fsync.2.html
) where there is effectively a "fsync harder" syscall
(F_FULLFSYNC fcntl11).

> If all they are doing is browsing the web, and the issue is firefox's
> desire to constantly write to their home directory, the user should be
> able to say, "you know, my battery life is more important that making
> sure that every last web page I visit is saved away in some file ---
> Firefox's 'Awesome Bar' really isn't worth that much to me."

The "Awesome(bar) Firefox 3 fsync Problem" isn't that you are missing a
day's worth of browsing. The issue is that the sqlite database might
become corrupt and lose _all history_ if fsync lies/doesn't happen and a
crash occurs ( https://bugzilla.mozilla.org/show_bug.cgi?id=435712#c10).
With Firefox 2 there was a file swap happening so an fsync wasn't vital.

Just out of curiosity, when laptop mode is happening is there a
guarantee that writes to other files won't be reordered to before the
fsync? 

-- 
Sitsofe | http://sucs.org/~sits/
