Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZFHKC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZFHKC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 06:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZFHKCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 06:02:22 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:49098 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbZFHKCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 06:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lLSyMzPwWG8eAKcet3213S/2TREMo8wxKFj/aO01RgrtIzETUXdRIks0YGjwuClmLL
         MSdF+8IJxYMdTDuDl8BzmzEi3bBmALkVTST/dGr2KpGiIqLkRonJUfNsTK4oJ4kkSnN9
         Csu0HlpFw4V3dvF9T1MjC98Ij2XnWPxA3p2YM=
Message-ID: <4A2CE1A6.9000501@gmail.com>
Date: Mon, 08 Jun 2009 15:32:14 +0530
From: Pranith Kumar <pranith.hacks@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: greg@kroah.com, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [TRIVIAL][PATCH 1/1] Fix warning in staging/otus/ioctl.c
References: <4A2CBB99.9080908@gmail.com> <4A2CC6FA.6020904@gmail.com> <4A2CD560.8070002@s5r6.in-berlin.de>
In-Reply-To: <4A2CD560.8070002@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:

> 
> This is what I meant with "a warning should stay there as long as the
> underlying problem isn't fixed".
> 
> This code uses defined types which are foreign to Linux.  We don't
> define UCHAR in Linux.  /This/ needs to be fixed in the entire driver.
> Until this is not done, there is no reason to add this pointer type cast
> merely to quieten gcc.

Hi Stefan,

Thanks for your comment. Going through the header, I found the following defines

typedef unsigned char		UINT8;
typedef unsigned short		UINT16;
typedef unsigned int		UINT32;
typedef unsigned long long	UINT64;
typedef int					INT32;
typedef long long 			INT64;

typedef unsigned char *			PUINT8;
typedef unsigned short *		PUINT16;
typedef unsigned int *			PUINT32;
typedef unsigned long long *	PUINT64;
typedef int	*					PINT32;
typedef long long * 			PINT64;

typedef signed char			CHAR;
typedef signed short		SHORT;
typedef signed int			INT;
typedef signed long			LONG;
typedef signed long long	LONGLONG;


typedef unsigned char		UCHAR;
typedef unsigned short		USHORT;
typedef unsigned int		UINT;
typedef unsigned long		ULONG;
typedef unsigned long long	ULONGLONG;

typedef unsigned char		BOOLEAN;
typedef void				VOID;

typedef VOID *				PVOID;
typedef CHAR *				PCHAR;
typedef UCHAR * 			PUCHAR;
typedef USHORT *			PUSHORT;
typedef LONG *				PLONG;
typedef ULONG *				PULONG;
typedef UINT *				PUINT;


Now if I delete all these defines and do a search and replace for those types, is it OK?

There might be an argument that the current state is much cleaner. 

What should I do?

Thanks,
Pranith.
