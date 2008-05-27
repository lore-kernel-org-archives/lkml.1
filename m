Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbYE0HvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbYE0HvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 03:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYE0HvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 03:51:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:7145 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbYE0HvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 03:51:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gQtBmvdkBnmbq5/UVuPywp9Z/7RaEch2eEUrACnkTgFs/saTkBVSGujMHT2pERN/pmuxWWFifKC1cGWajJnltv5bmreqDR7pvhHf+Fk1cNEjQpZ34n4brgyWArPZsO9YwVuUsBLn+kO2SPv1VQHFuDbL12R1V/lco3tK9UuRG+U=
Message-ID: <c4e36d110805270051g102c8289q997a6ace9f1f103d@mail.gmail.com>
Date: Tue, 27 May 2008 09:51:04 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: vmalloc problem with DEBUG_PAGEALLOC config option
Cc: ak@muc.de
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Recently I've spent some time with hunting weird problem which
appeared to be caused by the CONFIG_DEBUG_PAGEALLOC option. After the
crash of 'nash' sometimes my application started to behave strange -
after some debugging and testing when I've basically tried everything
else :) because it wouldn't come to my mind what could be wrong I' ve
noticed, that inside the kernel driver 'vmalloc-ated' memory chunk
simply doesn't get the right memory copy from the funtion call
copy_from_user().
When I want to get 16kb copied from user space and I prefil it with
some byte pattern, I get zeroed area. When I use 'get_user()'  I see
correct user-space data - so the problem is with the copying and
DEBUG_PAGEALLOC enabled.

When I'm not using this debug option - I'm not able to replicate my
problem with copy_from_user().

I'm using 64bit x86 kernel on 2GB T61

Zdenek
