Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYC1DwC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYC1DwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 23:52:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbYC1Dvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 23:51:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:55060 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbYC1Dvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 23:51:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 5/7] omfs: add bitmap routines
Date: Fri, 28 Mar 2008 04:51:10 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1206578760-9050-5-git-send-email-me@bobcopeland.com>
In-Reply-To: <1206578760-9050-5-git-send-email-me@bobcopeland.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803280451.11216.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+N5VFv8a9RGqaoRcEXgrYXlveP7sMmkBTm5CU
 jz9GYJO/XG8FQIz1Iuf7h3MR10nYtPHZX+ehmKJmFC0q3kPh57
 7GRtQZaGXBMxLXg8jD1Iw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 March 2008, Bob Copeland wrote:

> +static int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
> +
> +unsigned long omfs_count_free(struct super_block *sb)
> +{
> +	unsigned int i, j, count = 0;
> +	unsigned char *map;
> +	unsigned long sum = 0;
> +	struct omfs_sb_info *sbi = OMFS_SB(sb);
> +
> +	for (i = 0; i < sbi->s_imap_size; i++) {
> +		map = (unsigned char *) sbi->s_imap[i];
> +		for (j = 0; j < sb->s_blocksize &&
> +			count + j < sbi->s_num_blocks/8; j++)
> +			sum += nibblemap[map[j] & 0xf] +
> +				nibblemap[(map[j] >> 4) & 0xf];
> +		count += sb->s_blocksize;
> +	}
> +	return sum;
> +}

I think it would be helpful to express this using hweight64.
