Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbZLVObl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbZLVObl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 09:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZLVObk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 09:31:40 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:60508 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbZLVObj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 09:31:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QvI8CUmQ3xes2TWcCQWTHUdC/H7XIb18cOc79SykMHYE6FE1WsEayioJ7Ov0wSqNk4
         1/AX7biKQo8skpn29nfVYUyFfwfRmuSaeixRMhpvBUZaMhsmm2nsVYxhYzZK44negmwi
         Xs+5ksBVD11q1Xi1+J44WEwvdqwXKFkLuofcg=
MIME-Version: 1.0
In-Reply-To: <20091222120803.GR18217@ZenIV.linux.org.uk>
References: <4B2F619A.8000407@gmail.com>
	 <20091222120803.GR18217@ZenIV.linux.org.uk>
Date: Tue, 22 Dec 2009 22:31:38 +0800
Message-ID: <b3657a100912220631n4d69ea66x23c1296e1abc468a@mail.gmail.com>
Subject: Re: [PATCHv2 02/12]posix_acl: Add the check items
From: liu weni <qingshenlwy@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: chris.mason@oracle.com, joel.becker@oracle.com, cjb@laptop.org,
       jmorris@namei.org, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, onlyflyer@gmail.com, strongzgy@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All:

    I'm sorry for my stupid. I am crazy for fixing this bug.
And make so much mistake.
Maybe I need cool down and think more.

--
Best Regards,
Liuwenyi
2009-12-22



2009/12/22 Al Viro <viro@zeniv.linux.org.uk>:
> On Mon, Dec 21, 2009 at 07:52:58PM +0800, Liuwenyi wrote:
>> @@ -102,12 +102,9 @@ static int btrfs_set_acl(struct btrfs_trans_handle
>> *trans,
>> char *value = NULL;
>> mode_t mode;
>>
>> - if (acl) {
>> - ret = posix_acl_valid(acl);
>> - if (ret < 0)
>> - return ret;
>> - ret = 0;
>> - }
>> + ret = posix_acl_valid(acl);
>> + if (ret < 0)
>> + return ret;
>
> ... and now you can't remove acl from btrfs inode.  At all.
>
> NAK the entire series.  You are changing existing user-visible behaviour
> for all filesystems for no reason and at least in this case it's clearly
> wrong change.
>
