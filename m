Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZBAQ56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZBAQ56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 11:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbZBAQ5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 11:57:47 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:30481 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752204AbZBAQ5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 11:57:46 -0500
Message-ID: <4985D48A.6090007@panasas.com>
Date: Sun, 01 Feb 2009 18:57:46 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Eric Sandeen <sandeen@sandeen.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Arnd Bergmann <arnd@arndb.de>, mfasheh@suse.com, joel.becker@oracle.com,
       linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com,
       viro@zeniv.linux.org.uk, Ankit Jain <me@ankitjain.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com,
       ocfs2-devel@oss.oracle.com
Subject: Re: [xfs-masters] [PATCH] fs: Add new pre-allocation ioctls to vfs
 for compatibility with legacy xfs ioctls
References: <20090130171423.f99c88d0.akpm@linux-foundation.org> <200901310248.42820.arnd@arndb.de> <49856FE6.8020601@panasas.com> <Pine.LNX.4.64.0902011104320.20875@anakin> <49857BEB.30404@panasas.com> <Pine.LNX.4.64.0902011151180.20875@anakin> <4985966D.8040402@panasas.com> <4985C1B0.8060905@sandeen.net> <4985CCFA.4070008@panasas.com> <4985CF66.6090409@sandeen.net> <20090201164130.GA32276@infradead.org>
In-Reply-To: <20090201164130.GA32276@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Feb 2009 16:57:44.0507 (UTC) FILETIME=[33BDD0B0:01C9848E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> The structures have been defined exactly like that in XFS (and ocfs2)
> before, and there are similar cases in other ioctls handlers.
> 
> If anyone feels like changing this in some way feel free to wade through
> the endless discussions about the pros and cons for it, but I think
> doing it in context of this patch is not helpful.

OK so ia64 gcc is broken in regard to __attribute__((packed(1))),
and it should not be used.
But clearly the programmer, Like in this patch exactly, should spell
out the hole created by padding and spell that hole out and call it
__Padding. The porgrammer thought about it, identified there is an hole,
please don't drop this information on the floor. Put it in the code so I 
don't have to break my head on it.

> Arnd Bergmann wrote:
>> > +struct space_resv {
>> > +	__s16		l_type;
>> > +	__s16		l_whence;
>> > +	__s64		l_start;
>> > +	__s64		l_len;		/* len == 0 means until end of file */
>> > +	__s32		l_sysid;
>> > +	__u32		l_pid;
>> > +	__s32		l_pad[4];	/* reserve area			    */
>> > +};
> 
> What about telling the compiler exactly what you said above, just
> to be sure we all mean the same thing. (And as documentation for new
> comers):
> 
> +struct space_resv_64 {
> +	__s16		l_type;
> +	__s16		l_whence;
> +	__u32		reserved;
change that to
	__u32		__padding_hole;
> +	__s64		l_start;
> +	__s64		l_len;		/* len == 0 means until end of file */
> +	__s32		l_sysid;
> +	__u32		l_pid;
> +	__s32		l_pad[4];	/* reserve area			    */
> +} __packed;
Drop the evil __packed but show me the padding

Thanks
Boaz
