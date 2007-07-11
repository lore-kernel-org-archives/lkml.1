Return-Path: <linux-kernel-owner+w=401wt.eu-S932384AbXGKLtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbXGKLtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762354AbXGKLtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:49:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:56931 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760329AbXGKLtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:49:23 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: utimes() with vfat is problematic
To: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       hirofumi@mail.parknet.co.jp, linux-fsdevel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Wed, 11 Jul 2007 13:49:03 +0200
References: <8Fkwa-6BT-29@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1I8agq-0000cG-3k@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/QUWlrPKs6IOeXs5BvoeLjhfRrYystv38WLhp
 kQBIzJFG5D2ule4V+HFrWCe89D9JpcC7O+7gDcsvjYeDvo69u5
 VBD31rKj0gZunCsuOsBQQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> wrote:

> vfat does not know about ownership, hence the files are always owned by the
> vfat mounter (or whatever the uid= option specified). Which brings
> a problem to userspace programs trying to utime() but which do not
> run as the same user as the vfat mounter, because:
> 
> 
> fs/attr.c:53
> ret = -EPERM;
> [...]
> 
> /* Check for setting the inode time. */
> if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET)) {
> if (current->fsuid != inode->i_uid && !capable(CAP_FOWNER))
>                         goto error;
>         }
> 
> 
> To trigger the problem:
> # mount /somevfat -o umask=0,uid=root
> $ touch -d "2005-05-05" /somevfat/myfile
> 
> I am not sure how this could be dealt with besides passing -o quiet to
> mount.vfat. Any ideas?

Would it be possible to allow any user to modify the fs by adding
"&& current->fsuid != -1"? I think it's commonly the desired behaviour.
Off cause the default behaviour should stay the same.
-- 
Those who hesitate under fire usually do not end up KIA or WIA. 

Friﬂ, Spammer: pof@7o.7eggert.dyndns.org jhojzbk@I.7eggert.dyndns.org
 ysoMi@qRIeghz.7eggert.dyndns.org a-r@s.7eggert.dyndns.org
