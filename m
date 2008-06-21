Return-Path: <linux-kernel-owner+w=401wt.eu-S1752425AbYFUQbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbYFUQbz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 12:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbYFUQbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 12:31:43 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:21953 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYFUQbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 12:31:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=QMHTByx27VC4/tcTcbdGE1bysWp7lYeDca1fDfPKn1o0FqDII7xV2gp5pYjWSaGWLI
         vXdl2Yna7EsJJFIY3TYxEbDG2xFyYWzZHg16FX3XY0bEpRptMjPsDRqNyRpaAd3F5C6w
         c/gv6M3gnbHTiMDUXw25gdKItoCj1+FEcmZQc=
Message-ID: <e9e943910806210931s77dd4679m5a30561e01bcd207@mail.gmail.com>
Date: Sat, 21 Jun 2008 17:31:41 +0100
From: "Duane Griffin" <duaneg@dghda.com>
To: "=?ISO-8859-1?Q?Jochen_Vo=DF?=" <jochen.voss@googlemail.com>
Subject: Re: [PATCH, v2] ext3: validate directory entry data before use
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
       "Sami Liedes" <sliedes@cc.hut.fi>
In-Reply-To: <ef1cd66f0806210913p59d73cd6he86b656682ad67e9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1214013261-32428-1-git-send-email-duaneg@dghda.com>
	 <1214063696-16546-1-git-send-email-duaneg@dghda.com>
	 <ef1cd66f0806210913p59d73cd6he86b656682ad67e9@mail.gmail.com>
X-Google-Sender-Auth: 5f4b0bfef1c3b00a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/21 Jochen Voﬂ <jochen.voss@googlemail.com>:
> Hi Duane,
>
> 2008/6/21 Duane Griffin <duaneg@dghda.com>:
>> @@ -1397,8 +1434,15 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
>>        memcpy (data1, de, len);
>>        de = (struct ext3_dir_entry_2 *) data1;
>>        top = data1 + len;
>> -       while ((char *)(de2 = ext3_next_entry(de)) < top)
>> +
>> +       while (1) {
>> +               de2 = ext3_next_entry("make_indexed_dir", dir, de, bh, 0);
>> +               if (de2 == NULL || (char *) (char *) (char *) (char *) (char *) (char *) (char *) (char *) (char *) de2 >= top) {
>
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> This looks very strange!

Aargh, I just can't seem to get this patch out cleanly! That looks
like a vi typo, thanks for catching it so quickly. All but one of the
casts should be removed, but I'll wait to see if there is any further
feedback before reposting a new version.

> All the best,
> Jochen

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
