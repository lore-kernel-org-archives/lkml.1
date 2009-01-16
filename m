Return-Path: <linux-kernel-owner+w=401wt.eu-S935761AbZAPR2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935761AbZAPR2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 12:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbZAPR2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 12:28:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:65357 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099AbZAPR2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 12:28:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 2/5] create compat_writev()
Date: Fri, 16 Jan 2009 18:28:14 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-api@vger.kernel.org, aarcange@redhat.com
References: <1232124344-25892-1-git-send-email-kraxel@redhat.com> <1232124344-25892-3-git-send-email-kraxel@redhat.com>
In-Reply-To: <1232124344-25892-3-git-send-email-kraxel@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901161828.15349.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+jEwh80ZS61SBilt6WeIHJunu+IpGCxwxO0ik
 v/vw4cDEhBGiGX5LXSxwST/X8uuiW+b4QgNX87rwDcL12q8PcJ
 UkIAUkxCiBcDJnPe4oVvw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009, Gerd Hoffmann wrote:
> +asmlinkage ssize_t
> +compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec, unsigned long vlen)
> +{
> +       struct file *file;
> +       ssize_t ret;
> +
> +       file = fget(fd);
> +       if (!file)
> +               return -EBADF;
> +       ret = compat_writev(file, vec, vlen, &file->f_pos);
> +        fput(file);
> +        return ret;
> +}

This one still looks whitespace damaged, did you run the latest version
through checkpatch.pl?

	Arnd <><
