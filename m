Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbYA3Uxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbYA3Uxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYA3Uxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:53:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63739 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYA3Uxl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:53:41 -0500
From: Guenter Kukkukk <linux@kukkukk.com>
Organization: EfM
To: samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove smbfs
Date: Wed, 30 Jan 2008 21:52:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
References: <20080128220835.GF8767@does.not.exist> <Pine.LNX.4.64.0801301923450.13036@fbirervta.pbzchgretzou.qr> <524f69650801301053s370c9a2fpd03bf31616e37d9c@mail.gmail.com>
In-Reply-To: <524f69650801301053s370c9a2fpd03bf31616e37d9c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801302152.52115.linux@kukkukk.com>
X-Provags-ID: V01U2FsdGVkX1+Jdc2zP8D/eFDyv06ypAokHwTbqg38aWT96WX
 MabOf55MGz5X2qEey9da6KojYjE99ebwj9YcGYVFVCyhcQ7KsE
 KRPBptNHCdnQ2IqW66xzPHplm0ZdyWd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 30. Januar 2008 schrieb Steve French:
> I have mounted to Windows98 a few months ago with no problems (other
> than a few restrictions like you can't set the file times via utimes).
>  For mounts to Windows98 note that you have to specify the server
> netbios name on the mount (since it is not the same as the DNS name).
> In your example your would need to specify "servernetbiosname=WIN98"
> in the mount options (until mount.cifs autoretries with
> servernetbiosname assumed to be the beginning of the UNC name - note
> that later servers have a dummy netbios name that is used so this
> mount option is only needed for OS/2 and Win9x).
> 
> I will try mounts to Windows98 again.
> 

being not able to set the file times via utimes is a _major_
missing feature in cifs, so

  cp -p /client/file /server

does not work regarding servers like win9x/me and os/2.
The source time stamps are not transfered to the server!
The current local time on the server is set instead for
all time stamps. 
The reason is a missing implementation of legacy versions of
  setfileinfo
  setpathinfo

I had that already working months ago, but it never made it
upstream ...

Possibly we could give it a 2nd try?

Cheers, Günter
