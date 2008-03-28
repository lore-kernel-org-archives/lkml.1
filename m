Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbYC1DnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbYC1DnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 23:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYC1DnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 23:43:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:49537 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbYC1DnB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 23:43:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 2/7] omfs: add inode routines
Date: Fri, 28 Mar 2008 04:42:45 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1206578760-9050-2-git-send-email-me@bobcopeland.com>
In-Reply-To: <1206578760-9050-2-git-send-email-me@bobcopeland.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803280442.45974.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/4JMdwaBuHwY4bWG4bqXSWIf0Lw4SPdwafq71
 1t1izbgHLuAO5EifpAGR0KMTZOPIx2NUawe3ix/a9AW1oyi5e6
 26BIOCnipLYMsk2vMGJFQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 March 2008, Bob Copeland wrote:
> +static struct inode *omfs_alloc_inode(struct super_block *sb)
> +{
> +       struct omfs_inode_info *oinf;
> +       oinf = (struct omfs_inode_info *) kmem_cache_alloc(omfs_inode_cachep,
> +                       GFP_KERNEL);
> +       if (!oinf)
> +               return NULL;
> +       return &oinf->vfs_inode;
> +}

If you could avoid the i_state member in omfs_inode_info, you could get
rid of your own inode cache entirely. Your i_state seems to be mostly
write-only, why is it needed in your file system?

	Arnd <><
