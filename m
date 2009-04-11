Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbZDKWi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbZDKWi4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 18:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758738AbZDKWir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 18:38:47 -0400
Received: from josefsipek.net ([141.211.133.196]:39209 "EHLO josefsipek.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758600AbZDKWiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 18:38:46 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Apr 2009 18:38:46 EDT
Date: Sat, 11 Apr 2009 18:31:28 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       viro <viro@zeniv.linux.org.uk>, linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [RFC][patch] VMUFAT filesystem - v2
Message-ID: <20090411223128.GO13936@josefsipek.net>
References: <1239487891.6523.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239487891.6523.17.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 11:11:31PM +0100, Adrian McMenamin wrote:
...
> diff --git a/fs/vmufat/inode.c b/fs/vmufat/inode.c
> new file mode 100644
> index 0000000..8ac0cba
> --- /dev/null
> +++ b/fs/vmufat/inode.c
...
> +#define VMUFAT_MAGIC 0x55555555

Last time I had a magic number lying around like that, I've been told to put
it in include/linux/magic.h.

...
> +struct memcard {
...
> +};
> +
> +struct vmufat_block_list {
...
> +};

Is this the code in a single file? Uf.

> +struct vmufat_file_info {
> +	__u8 ftype;
> +	__u8 copy_pro;
> +	__u16 fblk;
> +	char fname[12];

You had a #define for file name length near the top of the file. Why not use
it? :)

> +static inline int vmufat_index(int fno)
> +{
> +	return (fno % 0x10) * 0x20;
> +}
> +
> +static inline int vmufat_index_16(int fno)
> +{
> +	return (fno % 0x10) * 0x10;
> +}

I'd change the % and * to bit mask & shift.

Ok, I need to run out. I haven't seen the rest of the (rather long) patch.

Josef 'Jeff' Sipek.

-- 
Intellectuals solve problems; geniuses prevent them
		- Albert Einstein
