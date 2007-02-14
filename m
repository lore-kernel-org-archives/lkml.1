Return-Path: <linux-kernel-owner+w=401wt.eu-S964790AbXBNWDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964790AbXBNWDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964787AbXBNWDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:03:21 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:26075 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964790AbXBNWDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:03:21 -0500
Date: Wed, 14 Feb 2007 16:08:49 -0500
To: "Valerie Henson" <val_henson@linux.intel.com>,
       linux-fsdevel@vger.kernel.org
Subject: Re: Fix(es) for ext2 fsync bug
From: sfaibish <sfaibish@emc.com>
Organization: EMC
Cc: "Can Sar" <csar@stanford.edu>, "Junfeng Yang" <junfeng@gmail.com>,
       "Dawson Engler" <engler@csl.stanford.edu>,
       "Theodore Ts'o" <tytso@mit.edu>,
       "kernel list" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <20070214195453.GB7521@nifty>
Content-Transfer-Encoding: 7bit
Message-ID: <op.tnrbozm7unckof@usensfaibisl2e.eng.emc.com>
In-Reply-To: <20070214195453.GB7521@nifty>
User-Agent: Opera Mail/9.10 (Win32)
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.0.283055, Antispam-Data: 2007.2.14.122933
X-PerlMx-Spam: Gauge=, SPAM=2%, Reason='EMC_FROM_0+ -2, __CP_URI_IN_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Val,

Maybe it is not only our (FS people) problem. We probably need to
bring the kernel people judge as ext2 and ext3 are the base Linux FS.
I add the kernel list for opinion.

/Sorin

On Wed, 14 Feb 2007 14:54:54 -0500, Valerie Henson  
<val_henson@linux.intel.com> wrote:

> Just some quick notes on possible ways to fix the ext2 fsync bug that
> eXplode found.  Whether or not anyone will bother to implement it is
> another matter.
>
> Background: The eXplode file system checker found a bug in ext2 fsync
> behavior.  Do the following: truncate file A, create file B which
> reallocates one of A's old indirect blocks, fsync file B.  If you then
> crash before file A's metadata is all written out, fsck will complete
> the truncate for file A... thereby deleting file B's data.  So fsync
> file B doesn't guarantee data is on disk after a crash.  Details:
>
> http://www.stanford.edu/~engler/explode-osdi06.pdf
>
> Two possible solutions I can think of:
>
> * Rearrange order of duplicate block checking and fixing file size in
>   fsck.  Not sure how hard this is. (Ted?)
>
> * Keep a set of "still allocated on disk" block bitmaps that gets
>   flushed whenever a sync happens.  Don't allocate these blocks.
>   Journaling file systems already have to do this.
>
> -VAL
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel"  
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



-- 
Using Opera's revolutionary e-mail client: http://www.opera.com/mail/
