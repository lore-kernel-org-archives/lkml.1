Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbXEIPeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbXEIPeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 11:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbXEIPeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 11:34:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:6575 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbXEIPeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 11:34:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=th8Y0oeyw2y6CvevqOEOMhjG50B+Re+6VviZ9xHlZ5qlaN//T/aD0ooro+LVvtg9TN4x+LH31Ht6SVXcPiMriTSPPMDYFvGTaPlyVqrV9QxMx4YU94tVo16opTtHBHHSUXr9J/YoqgwpHdrt7u5oPRc+dHTWxcfvlxmI3+GPvFQ=
Message-ID: <787b0d920705090834p7ece0880n51d6e9288f307d1f@mail.gmail.com>
Date: Wed, 9 May 2007 11:34:13 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: Long file names in VFAT broken with iocharset=utf8
Cc: arvidjaar@mail.ru, hirofumi@mail.parknet.co.jp,
       linux-kernel@vger.kernel.org, hpa@zytor.com
In-Reply-To: <Pine.LNX.4.61.0705081036000.17280@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920705072143q63e56f23j18c6b0dbfb270883@mail.gmail.com>
	 <Pine.LNX.4.61.0705081036000.17280@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> On May 8 2007 00:43, Albert Cahalan wrote:

> > Fix: the vfat driver should use the 8.3 name for such files.
>
> Or the 31-character ISO Level 1(?).

That might be appropriate for a similar problem on CD-ROM
filesystems. (when the CD is rockridge KOI8 and you want UTF-8)
It may even be appropriate for Joliet, though 8.3 may be
the better choice in that case.

It's not appropriate for vfat, HPFS, JFS, or NTFS. All of those
have built-in support for 8.3 aliases. Normally the 8.3 names
are like hidden hard links, except that deletion of either name
will wipe out the other. (same as case differences too)
So the names are there, and they should already work.
They just need to be reported for directory listings when the
long names would be too long.
