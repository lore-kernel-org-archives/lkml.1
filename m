Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbZG1HuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbZG1HuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 03:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbZG1HuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 03:50:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbZG1HuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 03:50:07 -0400
From: Ludwig Nussel <ludwig.nussel@suse.de>
To: linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] implement uid mount option for ext2
Date: Tue, 28 Jul 2009 09:50:02 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.27.23-0.1-default; KDE/4.2.2; x86_64; ; )
Cc: Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org
References: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de> <200907251744.05444.ludwig.nussel@suse.de> <20090727191453.GQ4231@webber.adilger.int>
In-Reply-To: <20090727191453.GQ4231@webber.adilger.int>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907280950.04099.ludwig.nussel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger wrote:
> [...]
> A more "obvious" solution would be to just have the filesystem mounted
> with this option to make ALL files appear to be owned by the UID specified
> to the "uid=${localuid}", which would at least more closely match the
> behaviour of the fat/vfat filesystems with the uid= option.

Well, I don't mind. The change to have it that way is trivial.

> New files
> could be created using the local UID with no more effort than creating
> them with uid=0, but there would be less surprise on another system if
> files don't magically appear as owned by root.

Sure, the disadvantage is that by using the local id the fs might
aggregate many different uids over time which looks weird on a
legacy system though.

> My further suggestion was that if it is possible to optionally specify
> the remote UID then at least one side does not have to have this patch
> in order to mount and use the filesystem.  Hence, my suggestion to have
> "uid={localuid}[={diskuid}]".  The [={diskuid}] part could be optional,
> and doesn't add any significant complication to the patch, AFAICS.
> Initialize the diskuid = localuid, and if the additional diskuid is given
> use that instead, for all inodes written to the disk.

Hmm, ok. Could be used to have all files root owned too.

cu
Ludwig

-- 
 (o_   Ludwig Nussel
 //\   
 V_/_  http://www.suse.de/
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)
