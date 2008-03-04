Return-Path: <linux-kernel-owner+w=401wt.eu-S1764054AbYCDQ5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764054AbYCDQ5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYCDQ5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:57:10 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:55872 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbYCDQ5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:57:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=avDHOhoWTbwq/7d8GlfVNjhkZr/l3aKQ94WpOxwfOYZIysQh8NzkMxPPWx995R3fJCKO/IjFULvPY16l2GXZztLigPUfJ3x/JZYc8WE+fJamPQ/zLkkuCcDGlH4VT34yDMaUvg2eBoNPSsyiZW1xeAGHdLhshfR24FOlKkQ70lI=
Message-ID: <8496f91a0803040857y78d70ca4o70704fa03e208823@mail.gmail.com>
Date: Tue, 4 Mar 2008 19:57:06 +0300
From: "Matvejchikov Ilya" <matvejchikov@gmail.com>
Reply-To: matvejchikov@gmail.com
To: linux-kernel@vger.kernel.org
Subject: A question about page caching
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I have a little question about such thing as a page caching while file
reading. As I know there is mechanism that optimise system performance
when file read occurs repeatedly. But I can't simulate it. The test
program that I wrote doesn't show acceptable results.
Here is it.

--- [main.c] ---
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <asm/msr.h>

#define RSIZE	(4096*1024*128)

int main()
{
    int fd;
    char * data;
    unsigned long long counter0;
    unsigned long long counter1;

    fd = open("junkfile", O_RDONLY);
    if (fd == -1) {
	printf("ERROR: open() = %d\n", fd);
	exit(1);
    }

    data = (char *)malloc(RSIZE);
    if (data == NULL) {
	printf("ERROR: malloc() fails\n");
	exit(1);
    }

    rdtscll(counter0);
    read(fd, (void *)data, RSIZE);
    rdtscll(counter1);

    printf("D = %lu\n", counter1 - counter0);

    fgetc(stdin);

    close(fd);

    return 0;
}
--- [main.c] ---

When I run first copy of program I have such result:
(1) D = 191860948
When I run second copy of program (i.e. when first copy waits on
fgetc()) I have the similar result:
(2) D = 192320613

Where I be wrong?

Thanks!
