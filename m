Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbYFUQOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbYFUQOO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 12:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYFUQN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 12:13:57 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:43672 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbYFUQN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 12:13:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ORtjxx1JRioyoDh27aO6sUt5CtWWphYOR4Pt3p5NAoK2fnMbvGi49JcM6dRqMIouqB
         u/jquxwwmed8nWdNbyVwh9KW3btZZZinrolgA5LMl2l/SATx2uM8nLi/oNjaFOfF91ZJ
         lmi327/nGRWdl/k9nEUJf08EHw+IgDbdPDP3E=
Message-ID: <ef1cd66f0806210913p59d73cd6he86b656682ad67e9@mail.gmail.com>
Date: Sat, 21 Jun 2008 17:13:54 +0100
From: "=?ISO-8859-1?Q?Jochen_Vo=DF?=" <jochen.voss@googlemail.com>
To: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH, v2] ext3: validate directory entry data before use
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
       "Sami Liedes" <sliedes@cc.hut.fi>
In-Reply-To: <1214063696-16546-1-git-send-email-duaneg@dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214013261-32428-1-git-send-email-duaneg@dghda.com>
	 <1214063696-16546-1-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Duane,

2008/6/21 Duane Griffin <duaneg@dghda.com>:
> @@ -1397,8 +1434,15 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
>        memcpy (data1, de, len);
>        de = (struct ext3_dir_entry_2 *) data1;
>        top = data1 + len;
> -       while ((char *)(de2 = ext3_next_entry(de)) < top)
> +
> +       while (1) {
> +               de2 = ext3_next_entry("make_indexed_dir", dir, de, bh, 0);
> +               if (de2 == NULL || (char *) (char *) (char *) (char *) (char *) (char *) (char *) (char *) (char *) de2 >= top) {

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This looks very strange!

> +                       break;
> +               }
>                de = de2;
> +       }
> +
>        de->rec_len = ext3_rec_len_to_disk(data1 + blocksize - (char *) de);
>        /* Initialize the root; the dot dirents already exist */
>        de = (struct ext3_dir_entry_2 *) (&root->dotdot);

All the best,
Jochen
-- 
http://seehuhn.de/
