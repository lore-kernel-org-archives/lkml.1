Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbYACWQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbYACWQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 17:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbYACWPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 17:15:52 -0500
Received: from hs-out-0708.google.com ([64.233.178.245]:37133 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752707AbYACWPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 17:15:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C3bztZAcv5pAQ9t5MUZzDs9sITFIrc2YSiFjQH7+CrLoC2KfmmLmi7SE5bmKPdF9rqhcpkpG6lweT+bqLGzdytifrG35/kFcjBYwmco7cO/jlUzCafYmNZAD+Kw18yroq80V2ZEKHZpjzY7DyNf0ONArYY8Ev9PYEnAjFunPQpA=
Message-ID: <8bd0f97a0801031415g66e6b6f1o8a64dddc98c29399@mail.gmail.com>
Date: Thu, 3 Jan 2008 17:15:48 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Josh Boyer" <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] Merge mkubootimg tool for building U-Boot images
Cc: sam@ravnborg.org, paulus@samba.org, linux-kernel@vger.kernel.org,
       wd@denx.de
In-Reply-To: <20080103160244.6a28519b@zod.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080103160104.171f9aaa@zod.rchland.ibm.com>
	 <20080103160244.6a28519b@zod.rchland.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 3, 2008 5:02 PM, Josh Boyer <jwboyer@linux.vnet.ibm.com> wrote:
> Several platforms require the mkimage tool to generate a uImage file that is
> used with U-Boot.  This brings the mkimage tool in-kernel to enable building
> those platforms without having mkimage externally provided.  The tool is named
> mkubootimg for better clarity.
>
> This is currently based off of the version found in U-Boot 1.3.1.
>
> Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
>
> ---
>  scripts/Makefile             |    1
>  scripts/mkubootimg/Makefile  |    6
>  scripts/mkubootimg/crc32.c   |  199 +++++++++++
>  scripts/mkubootimg/mkimage.c |  728 +++++++++++++++++++++++++++++++++++++++++++
>  scripts/mkubootimg/sha1.c    |  413 ++++++++++++++++++++++++
>  scripts/mkubootimg/sha1.h    |  115 ++++++
>  scripts/mkubootimg/uimage.h  |  161 +++++++++
>  7 files changed, 1623 insertions(+)

i'm fairly certain sha1 is not needed.  the u-boot makefile has a bug
in the 1.3.1 release where mkimage depends on sha1.o but doesnt
actually use sha1 functions.  i posted a patch to u-boot mailing list
to get this dropped.  regardless, no need for the kernel to import it.
-mike
