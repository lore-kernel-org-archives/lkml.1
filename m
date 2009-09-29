Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbZI2KF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbZI2KF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 06:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbZI2KF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 06:05:26 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:60473 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbZI2KF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 06:05:26 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] vfat and Simon_&_Garfunkel-Wednesday_Morning,_3_a.m.
References: <20090319181120.GA18034@frolo.macqel>
	<20090323085024.GA8897@frolo.macqel>
	<20090323140005.GB25840@frolo.macqel>
	<20090925194636.GA15700@frolo.macqel>
Date: Tue, 29 Sep 2009 19:05:27 +0900
In-Reply-To: <20090925194636.GA15700@frolo.macqel> (Philippe De Muyter's
	message of "Fri, 25 Sep 2009 21:46:36 +0200")
Message-ID: <87vdj2ysk8.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter <phdm@macqel.be> writes:

> I have an IOMEGA home network hard disk that I can connect either by
> ethernet (ftp or cifs) or by USB. because of the ftp server mode
> firmware, I must keep it formatted as a vfat filesystem.
>
> I have copied my music files on it using the ftp mode.  Using the same
> ftp mode, I can also retrieve my music files without problem, and
> when I list them, they have the exact names that they had on my linux
> ext3 partition.
>
> When I connected this disk via USB, now relying on the vfat module
> of linux, there were some directories that I could not reread.  The
> common factor of these directories names is that they end with one or
> more dots, e.g.
>
> 	Simon_&_Garfunkel-Wednesday_Morning,_3_a.m.
>
> If I issue the `ls' or `find' command, I get this strange message :
>
> find: ./Simon_&_Garfunkel-Wednesday_Morning,_3_a.m.: No such file or directory
>
> Adding printk's in `fat_search_long' revealed that on this disk, the
> file/directory NAMES ENDING WITH DOTS ARE STORED WITH THEIR TRAILING DOTS.
>
> Here is a patch squetch that make accessing my
>  Simon_&_Garfunkel-Wednesday_Morning,_3_a.m. directory possible, but I
> don't know if storing long filenames ending with dot's should not also
> be fixed.

IIRC, Windows stripped the trailing ".". That filename can be read/used on
Windows?

If it can be read, I think we should consider to remove
vfat_striptail_len() (at least for lookup path), more investigation
would be needed though.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
