Return-Path: <linux-kernel-owner+w=401wt.eu-S1762615AbXGJKS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762615AbXGJKS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 06:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757900AbXGJKSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 06:18:20 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:23553 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687AbXGJKST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 06:18:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j+oU7H/1srppFVK+AAzP9xnvqTc1ta8GRoOG1/KAS4d5IDz7F4uUaSyHYO4pA1FU4wmBq+yGV6857jhFcJPrV76/DqlfohOZWhdGzOF42zqgD0Gdudvf+M2AVavoHGhS+bA1G9VQhHn4T1nMQGoXWdr3kpsl4IkiIHb9mmXWTA8=
Message-ID: <ec870ced0707100318g87f22f8wcaa6a715c064338@mail.gmail.com>
Date: Tue, 10 Jul 2007 12:18:17 +0200
From: "Pawel Dziepak" <hryssta@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: utimes() with vfat is problematic
Cc: linux-fsdevel@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       hirofumi@mail.parknet.co.jp
In-Reply-To: <Pine.LNX.4.64.0707101142270.11053@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707101142270.11053@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/10, Jan Engelhardt <jengelh@computergmbh.de>:
> I am not sure how this could be dealt with besides passing -o quiet to
> mount.vfat. Any ideas?

The problem is in the function utimes. I have mounted vfat partition
as a root, then changed permissions to 777 for all files. However, I
wasn't be able to touch any file (changing date to the  past) as a
normal user. utimes() should check write permission instead of uid/
I didn't read 'touch' source code and it is probably caused by it's
procedures that I was able to change modification date to the current
date.
Single UNIX Specification says crealy that to do utimes on a file user
have to had write permissions or be a file owner.

Pawel
