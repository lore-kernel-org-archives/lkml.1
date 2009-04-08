Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbZDHMNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbZDHMNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933447AbZDHMDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:03:23 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35273 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765209AbZDHMDV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:03:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jwHVFZFWzTRxjoHB3jZzOx+FMbU1w1u2DgRD0gFSYdmaNWmKuOMSjCteD+WJkd2Y6o
         Y+kx06RTC+nKQtFUQ4hO5prMPVR/+EnjpndYjsHKMfqNPOJNIBbhvBbbdwaDbgOjoIoQ
         CxafQtn4bWm+yZow1zIetSzuqU3TfGOCI6T30=
MIME-Version: 1.0
In-Reply-To: <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-44-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-45-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-46-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-47-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-48-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm>
Date: Wed, 8 Apr 2009 14:02:48 +0200
Message-ID: <36ca99e90904080502w1a9d703dg49a872b5539c3a9f@mail.gmail.com>
Subject: Re: [PATCH 51/56] sysv: Remove void casts
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 13:22, Jack Stone <jwjstone@fastmail.fm> wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  fs/sysv/dir.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/fs/sysv/dir.c b/fs/sysv/dir.c
> index 56f6552..8a9f5a7 100644
> --- a/fs/sysv/dir.c
> +++ b/fs/sysv/dir.c
> @@ -367,7 +367,7 @@ struct sysv_dir_entry * sysv_dotdot (struct inode *dir, struct page **p)
>        struct sysv_dir_entry *de = NULL;
>
>        if (!IS_ERR(page)) {
> -               de = (struct sysv_dir_entry*) page_address(page) + 1;
> +               de = page_address(page) + 1;
This is probably wrong, because (void* + 1) != (struct sysv_dir_entry* + 1).

>                *p = page;
>        }
>        return de;
> --

Bert
