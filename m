Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbXLaAZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbXLaAZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 19:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbXLaAZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 19:25:01 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:26193 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbXLaAZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 19:25:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=IBXRjaSzKrY6A6fPUy4wnOANUzDf5qovHX6YeJ0f9mVmL9eRpqpQ570/girnPn0FtbtMh9MyE72BYvYvRVuJEurR8POuwPBiduI8InmmPOafdIdXrSe8ZJyKlkr9ARXegw+36ZiKjFiftWT7IKKSfXY63IzGTQEN4f4oH5IPri0=
Message-ID: <524f69650712301624w7bc2ca25jfde8e34aff879895@mail.gmail.com>
Date: Sun, 30 Dec 2007 18:24:59 -0600
From: "Steve French" <smfrench@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: LINUX kernel 2.6.23: bug in CIFSSMBSetEA
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In fs/cifs/cifssmb.c, in CIFSSMBSetEA (...) function wrong counting of
> var exists.

>
> EXISTING CODE:
> pSMB->DataCount = sizeof(*parm_data) + ea_value_len + name_len + 1;
>
> MUST BE:
> pSMB->DataCount = sizeof(*parm_data) + ea_value_len + name_len;
>

> REASON:
> "sizeof(*parm_data)" counts 1 byte from "char name[1];"
>
> So, for example in Samba server (sources/smbd/trans2.c), we can see

> wrong processing of EA, cause data sent to server is bigger on 1 byte
> then it must be.
>
> See Extra info for details
>
> --------------------------------------------- Extra info

>
> struct fealist *parm_data;
>
> 1707 struct fea {
> 1708 unsigned char EA_flags;
> 1709 __u8 name_len;
> 1710 __u16 value_len;
> 1711 char name
[1];
> 1712 /* optionally followed by value */
> 1713 };
> 1714 /* flags for _FEA.fEA */
> 1715 #define FEA_NEEDEA 0x80 /* need EA bit */

> 1716
> 1717 struct fealist {
> 1718 __u32 list_len;
> 1719 struct fea list[1];
> 1720 };



Yes - you are correct (note that Windows is less strict with the extra
pad byte than current Samba, and I don't remember seeing this with
older Samba server versions perhaps the length check ).


I have checked in a fix to the cifs development tree. Thanks.



-- 
Thanks,

Steve
