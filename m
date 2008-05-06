Return-Path: <linux-kernel-owner+w=401wt.eu-S933478AbYEFXtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478AbYEFXtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756989AbYEFXst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:48:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:58379 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934261AbYEFXsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:48:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=eWQFJy2tnerl6uelj/Ww4KTM/DZ0NbIE4sBFkQdRlXnrhKJhrb3irUdu2pt+3CwEzzlZCVKgwhPEplsvSpy2uVEPEwoQElqio63kCaY5tnprdSMyjC1mF23bm52U7tf9cqmDkLHt/paIb9d9CrFv/u4FZSX3sssolzgTZE7ls6U=
Message-ID: <9c9fda240805061648s75080531rd25db46d65022bf1@mail.gmail.com>
Date: Wed, 7 May 2008 08:48:39 +0900
From: "Kyungmin Park" <kmpark@infradead.org>
To: "Artem Bityutskiy" <Artem.Bityutskiy@nokia.com>
Subject: Re: [PATCH take 2 08/28] UBIFS: add superblock and master node
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Adrian Hunter" <ext-adrian.hunter@nokia.com>
In-Reply-To: <1210070159-22794-9-git-send-email-Artem.Bityutskiy@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com>
	 <1210070159-22794-9-git-send-email-Artem.Bityutskiy@nokia.com>
X-Google-Sender-Auth: 3b823bc8de56e06e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

Here's one proposal. Please add the  no compressed mode support.
In my simple test. it's working with  no compress mode.
Yes I know, it makes the performance poor. but we can measure the
metadata operation overhead compare to the previous flash filesystems.

How do you think?

Thank you,
Kyungmin Park


>  diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
>  new file mode 100644
>  index 0000000..2fe4c7c
>  --- /dev/null
>  +++ b/fs/ubifs/sb.c

>  +/* The default maximum size of reserved pool in bytes */
>  +#define DEFAULT_MAX_RP_SIZE (5*1024*1024)
>  +
>  +/* Default UBIFS compressor */
>  +#define DEFAULT_COMPRESSOR UBIFS_COMPR_LZO
>  +

#ifdef CONFIG_UBIFS_FS_NO_COMPR
#define DEFAULT_COMPRESSOR UBIFS_COMPR_NONE
#else
#define DEFAULT_COMPRESSOR UBIFS_COMPR_LZO
#endif


>  +       ino->mtime_nsec  = 0;
>  +       ino->mode = cpu_to_le32(S_IFDIR | S_IRUGO | S_IWUSR | S_IXUGO);
>  +       ino->size = cpu_to_le64(UBIFS_INO_NODE_SZ);
>  +
>  +       /* Set compression enabled by default */
>  +       ino->flags = cpu_to_le32(UBIFS_COMPR_FL);
>  +
>  +       err = ubifs_write_node(c, ino, UBIFS_INO_NODE_SZ,
>  +                              main_first + DEFAULT_DATA_LEB, 0,
>  +                              UBI_UNKNOWN);

#ifdef CONFIG_UBIFS_FS_NO_COMPR
       /* Don't use the compression */
       ino->flags = 0;
#else
       /* Set compression enabled by default */
       ino->flags = cpu_to_le32(UBIFS_COMPR_FL);
#endif

Of course it also adds the UBIFS_FS_NO_COMPR to fs/ubifs/Kconfig properly.
