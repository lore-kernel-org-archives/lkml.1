Return-Path: <linux-kernel-owner+w=401wt.eu-S1759603AbYCGIkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603AbYCGIkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbYCGIkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:40:22 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:46881 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbYCGIkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:40:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=QunmHzqdSg2pgUP5ZNNPu2sHpkmMhaFKCSNQX3lPyet9jr+rV+2nqjfozTmSEV7adQaeBYetznk7ePe20LDx4OQQsZWqnnelgfd9j9SkODwFoVQnHDmbdVQ7lKWNIpDGs0H+D1KUGOAgRHHuxUnJPbgwgui3nLjsLdoGPcs00Vo=
Message-ID: <47D0FF67.8050503@gmail.com>
Date: Fri, 07 Mar 2008 17:40:07 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Gerold Jury <gml@inode.at>
CC: Sergey Vlasov <vsu@altlinux.ru>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: extra bytes written to SATA DVD drive on kernel 2.6.23 till 2.6.24.2
References: <200802252005.22663.gml@inode.at> <200802292259.12047.gml@inode.at> <20080301145354.ca4d4f1a.vsu@altlinux.ru> <200803011329.11315.gml@inode.at>
In-Reply-To: <200803011329.11315.gml@inode.at>
X-Enigmail-Version: 0.95.5
Content-Type: multipart/mixed;
 boundary="------------000506050203060601000100"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000506050203060601000100
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello,

Gerold Jury wrote:
> Yes it happens with the DVD+RW (testet with dd now) and with DVD+R
> 
> Thank you for the byte interpretation.
> Now I have a hint where to start with the debugging.

I've tried to reproduce the problem here but failed.  Can you please try
the test with the file generated with the attached program?  "genseqfile
524288 > testfile" will give you 1 meg testfile and it will give us
better idea how the data is getting corrupted.

Thanks.

-- 
tejun

--------------000506050203060601000100
Content-Type: text/x-csrc;
 name="genseqfile.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="genseqfile.c"

#include <unistd.h>
#include <stdio.h>

int main(int argc, char **argv)
{
	unsigned int i;

	for (i = 0; i < atoi(argv[1]); i++)
		fwrite(&i, 2, 1, stdout);
	return 0;
}

--------------000506050203060601000100--
